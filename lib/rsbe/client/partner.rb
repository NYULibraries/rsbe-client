require 'active_support'

module Rsbe
  module Client
    # Class simplifies interaction with RSBE Partner resources
    class Partner < Base
      def self.base_path
        super + '/partners'
      end

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
        rw_attrs + ro_attrs
      end

      # define setter methods for RW attributes
      rw_attrs.each { |m| define_method("#{m}=") {|v| @hash[m] = v} }

      # define getter methods for ALL attributes
      # all_attrs.each { |m| define_method("#{m}")  { @hash[m]} }
      all_attrs.each do |m|
        define_method("#{m}")  do
          @hash[m] || begin
                        # only fetch if Partner has a known id
                        if @hash[:id]
                          # TODO: CLEAN THIS UP
                          # This works currently because when a 404 is
                          # returned there is nothing in the response
                          # hash that matches the resource attributes,
                          # but relying on this behavior seems very
                          # brittle. Additionally, for every attribute
                          # queried, a GET operation is performed.
                          # Should store the object lifecycle state,
                          # e.g.,
                          # - new, no ID, no matching resource in RSBE: don't query RSBE
                          # - new, ID assigned, but not yet    in RSBE: don't query RSBE
                          # - existing, partially populated,
                          #   not fully updated with RSBE values:             query RSBE
                          # - existing, fully populated with data from RSBE
                          # - existing, local modifications, not persisted to RSBE
                          #
                          get
                          update_hash_nils_from_response
                        end
                        @hash[m]
                      end
        end
      end

      def initialize(vals = {})
        fail(ArgumentError, 'Constructor requires a Hash') unless vals.is_a?(Hash)
        super()
        @hash = {}
        @response = nil

        # initialize local hash with incoming values, restrict to RW attrs
        self.class.rw_attrs.each { |x| @hash[x] = (vals[x] || vals[x.to_s]) }
      end

      def collections
        fail 'Error getting collections' unless get_children('colls')
        JSON.parse(@response.body).collect do |json_hash|
          Rsbe::Client::Collection.new(json_hash)
        end
      end
    end
  end
end
