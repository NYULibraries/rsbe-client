require 'active_support'

module Rsbe
  module Client
    class Collection < Base
      def self.all
        raise Rsbe::Client::MethodNotImplementedError.new("Method not supported. Access via Rsbe::Client::Partner#collections")
      end

      def self.base_path
        super + '/colls'
      end

      def self.rw_attrs
        [:id, :code, :partner_id, :coll_type, :quota, :name, :rel_path]
      end

      def self.ro_attrs
        [:created_at, :updated_at, :lock_version]
      end

      def self.all_attrs
        self.rw_attrs + self.ro_attrs
      end

      # define setter methods for RW attributes
      self.rw_attrs.each  {|m| define_method("#{m}=") {|v| @hash[m] = v}}

      # define getter methods for ALL attributes
      self.all_attrs.each {|m| define_method("#{m}")  { @hash[m]}}

      def initialize(vals = {})
        raise ArgumentError.new("Constructor requires a Hash") unless vals.is_a?(Hash)
        super()
        @hash = {}
        @response = nil

        # initialize local hash with incoming values, restrict to RW attrs
        self.class.rw_attrs.each {|x| @hash[x] = vals[x]}
      end
      def create_path
        raise "partner_id not initialized!" unless partner_id
        Rsbe::Client::Partner.item_path(partner_id)
      end
    end
  end
end
