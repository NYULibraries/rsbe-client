require 'active_support'

module Rsbe
  module Client
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
    end
  end
end
