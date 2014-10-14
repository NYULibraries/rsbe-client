require 'active_support'

module Rsbe
  module Client
    class Partner < Base

      # implementation objectives:
      # - expose attributes via standard method calls
      # - use hash for internal representation to simplify passing data back and forth
      #   to back end app

      RW_ATTRS = [:id, :code, :name, :rel_path]
      RO_ATTRS = [:created_at, :updated_at, :lock_version]
      ALL_ATTRS = RW_ATTRS + RO_ATTRS

      # define setter methods for RW attributes
      RW_ATTRS.each  {|m| define_method("#{m}=") {|v| @hash[m] = v}}

      # define getter methods for all attributes
      ALL_ATTRS.each {|m| define_method("#{m}")  { @hash[m]}}

      def initialize(vals = {})
        super()
        @hash = {}
        # initialize local hash with incoming values, restrict to RW attrs
        RW_ATTRS.each {|x| @hash[x] = vals[x]}
      end

      def save
        # if id present
        #   GET to see if already exists
        #   if already exists, merge in @hash with response body, and PUT
        #   if DNE, then POST
        # id = hash[:id]
        # if id
        #   response = @conn.get item_path(id)
        #   case response.status
        #   when 200
        #     current_attrs = JSON.parse(response.body).to_h
        (has_id? && exists?) ? update : create
      end

      private

      def create
        response = @conn.post do |req|
          req.url coll_path
          req.headers['Content-Type'] = 'application/json'
          req.body = @hash.to_json
        end
        return false unless response.status == 201

        # need to update attributes with those on server
        response_hash = JSON.parse(response.body)
        raise "unable to parse response to hash" unless response_hash.is_a?(Hash)

        # if response body has a value then update hash
        # not using #update because keys may not be present in local hash,
        # and would need to symbolize response_hash keys
        ALL_ATTRS.each {|k| @hash[k] = response_hash[k.to_s] if response_hash[k.to_s]; puts "#{k}, #{response_hash[k.to_s]}"}

        true
      end

      def update
        # response = @conn.put do |req|
        #   req.url item_path(@hash[:id])
        #   req.headers['Content-Type'] = 'application/json'
        #   req.body = @hash.to_json
        # end
        # response.status == 201
      end

      def has_id?
        !@hash[:id].nil?
      end

      def exists?
#        @conn.get item_path(@hash[:id]).status == 200
      end


      def coll_path
        Rsbe::Client::Base::PATH + '/partners'
      end

      def item_path(id)
        coll_path + "/#{id}"
      end

      # internal representation should be a Hash
      # attr_accessor *RW_ATTRS = [:id, :code, :name, :rel_path, :lock_version]
      # attr_reader   *RO_ATTRS = [:created_at, :updated_at]

      # def initialize(vals ={})
      #   raise ArgumentError.new("#{vals} to be a Hash") unless vals.class == Hash

      #   # initialize writable instance variables
      #   RW_ATTRS.each { |k| instance_variable_set("@#{k}", vals[k]) }

      #   @collection_path = [Rsbe::Client::Base::PATH, 'partners'].join('/')
      # end

      # def self.find(id)
      #   @conn.get "#{@collection_path}/#{id}"
      # end

      # def self.all
      #   response = get(@path)
      #   JSON.parse(response.body).collect {|p| new(p)}
      # end

      # private
      # def self.get(path)
      #   response = @conn.get path
      #   raise "Error getting #{path}" unless response.status == 200
      #   response
      # end
    end
  end
end
