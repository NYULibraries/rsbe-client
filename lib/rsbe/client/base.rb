require 'faraday'
require 'json'

module Rsbe
  module Client
    class Base
      def initialize
        @conn = Rsbe::Client::Connection.new
      end
      def self.base_path
        '/api/v0'
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
        self.class.all_attrs.each {|k| @hash[k] = response_hash[k.to_s] if response_hash[k.to_s] }
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
        self.class.base_path
      end

      def item_path(id)
        coll_path + "/#{id}"
      end

      def self.rw_attrs
        []
      end

      def self.ro_attrs
        []
      end

      def self.all_attrs
        self.rw_attrs + self.ro_attrs
      end


    end
  end
end
