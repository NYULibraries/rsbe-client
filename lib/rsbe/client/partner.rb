require 'active_support'

module Rsbe
  module Client
    class Partner < Base

      def self.find(id)
        p = self.new(id: id)
        raise Rsbe::Client::RecordNotFound.new("Partner with #{id} not found") unless p.send(:get)
        p.send(:update_hash_from_response)
        p
      end

      # implementation objectives:
      # - expose attributes via standard setter/getter methods
      # - create getters for  all Read-Only  (RO) attributes
      # - create setters only for Read/Write (RW) attributes
      # - use hash for internal representation to simplify passing
      #   data back and forth to back end app

      RW_ATTRS  = [:id, :code, :name, :rel_path]
      RO_ATTRS  = [:created_at, :updated_at, :lock_version]
      ALL_ATTRS = RW_ATTRS + RO_ATTRS

      # define setter methods for RW attributes
      RW_ATTRS.each  {|m| define_method("#{m}=") {|v| @hash[m] = v}}

      # define getter methods for all attributes
      ALL_ATTRS.each {|m| define_method("#{m}")  { @hash[m]}}

      def initialize(vals = {})
        raise ArgumentError.new("Constructor requires a Hash") unless vals.is_a?(Hash)
        super()
        @hash = {}
        @response = nil

        # initialize local hash with incoming values, restrict to RW attrs
        RW_ATTRS.each {|x| @hash[x] = vals[x]}
      end

      def save
        (has_id? && exists?) ? update : create
      end


      private


      # N.B. intentionally not updating hash here
      def get(id = @hash[:id])
        @response = @conn.get item_path(id)
        @response.status == 200
      end

      def create
        @response = @conn.post do |req|
          req.url coll_path
          req.headers['Content-Type'] = 'application/json'
          req.body = @hash.to_json
        end
        return false unless @response.status == 201

        update_hash_from_response
        true
      end

      def update_hash_from_response
        raise "@response not initialized" if @response.nil?

        # update attributes with those from server
        response_hash = JSON.parse(@response.body)
        raise "unable to parse response to hash" unless response_hash.is_a?(Hash)

        # update object state
        ALL_ATTRS.each {|k| @hash[k] = response_hash[k.to_s] if response_hash[k.to_s] }
      end

      def update
        @response = @conn.put do |req|
          req.url item_path(@hash[:id])
          req.headers['Content-Type'] = 'application/json'
          req.body = @hash.to_json
        end

        success = @response.status == 204
        if success
          get
          update_hash_from_response
        end
        success
      end

      def has_id?
        !@hash[:id].nil?
      end

      def exists?
        get
      end

      def coll_path
        Rsbe::Client::Base::PATH + '/partners'
      end

      def item_path(id)
        coll_path + "/#{id}"
      end
    end
  end
end
