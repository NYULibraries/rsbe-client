require 'active_support'

module Rsbe
  module Client
    class Partner < Base

      def self.find(id)
        p = find_and_instantiate(id)
        raise Rsbe::Client::RecordNotFound.new("Partner with #{id} not found") if p.nil?
        p
      end

      def self.base_path
        super + '/partners'
      end

      # returns an array of Partner objects
      def self.all
        conn = Rsbe::Client::Connection.new
        local_response = conn.get base_path
        raise "Error retrieving partners" unless local_response.status == 200
        JSON.parse(local_response.body).collect {|json_hash| find_and_instantiate(json_hash['id'])}
      end

      def self.find_and_instantiate(id)
        p = self.new(id: id)
        if p.send(:get)
          p.send(:update_hash_from_response)
        else
          p = nil
        end
        p
      end
      private_class_method :find_and_instantiate

      # implementation objectives:
      # - expose attributes via standard setter/getter methods
      # - create getters for  all Read-Only  (RO) attributes
      # - create setters only for Read/Write (RW) attributes
      # - use hash for internal representation to simplify passing
      #   data back and forth to back end app

      def self.rw_attrs
        [:id, :code, :name, :rel_path]
      end

      def self.ro_attrs
        [:created_at, :updated_at, :lock_version]
      end

      def self.all_attrs
        self.rw_attrs + self.ro_attrs
      end

      # RW_ATTRS  = [:id, :code, :name, :rel_path]
      # RO_ATTRS  = [:created_at, :updated_at, :lock_version]
      # ALL_ATTRS = RW_ATTRS + RO_ATTRS

      # define setter methods for RW attributes
      self.rw_attrs.each  {|m| define_method("#{m}=") {|v| @hash[m] = v}}

      # define getter methods for all attributes
      self.all_attrs.each {|m| define_method("#{m}")  { @hash[m]}}

      def initialize(vals = {})
        raise ArgumentError.new("Constructor requires a Hash") unless vals.is_a?(Hash)
        super()
        @hash = {}
        @response = nil

        # initialize local hash with incoming values, restrict to RW attrs
        self.class.rw_attrs.each {|x| @hash[x] = vals[x]}
      end
    end
  end
end
