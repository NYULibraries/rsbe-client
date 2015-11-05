require 'active_support'

module Rsbe
  module Client
    # Class simplifies interaction with RSBE Partner resources
    class Collection < Base
      def self.all
        emsg = 'Method not supported. Access via Rsbe::Client::Partner#collections'
        fail Rsbe::Client::MethodNotImplementedError, emsg
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
        rw_attrs + ro_attrs
      end

      # define setter methods for RW attributes
      rw_attrs.each  { |m| define_method("#{m}=") { |v| @hash[m] = v } }

      # define getter methods for ALL attributes
      all_attrs.each { |m| define_method("#{m}")  { @hash[m] } }

      def initialize(vals = {})
        fail(ArgumentError, 'Constructor requires a Hash') unless vals.is_a?(Hash)
        super()
        @hash = {}
        @response = nil

        # initialize local hash with incoming values, restrict to RW attrs
        self.class.rw_attrs.each { |x| @hash[x] = (vals[x] || vals[x.to_s]) }
      end

      def create_path
        fail 'partner_id not initialized!' unless partner_id
        Rsbe::Client::Partner.item_path(partner_id)
      end
    end
  end
end
