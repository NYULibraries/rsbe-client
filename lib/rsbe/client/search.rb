module Rsbe
  module Client
    module Search
      def self.search(hsh = {})
        raise ArgumentError.new("These args must be present: #{hsh_valid_keys}") if hsh.empty?
        @hsh = hsh
        # check if search params are valid
        is_valid?
        @args = hsh[:params]
        @required_keys = hsh[:required_params]
        @scope = hsh[:scope]
        # check search args sent
        chk_search_args
        # build query url
        @search_url = query_search_url
        query
      end

      def self.query_search_url
        base_url = Rsbe::Client::Base.base_path
        query_hsh = parameterize_params
        search_url = "#{base_url}/#{search_url_fragment}?#{query_hsh}"
      end

      def self.query
        conn = Rsbe::Client::Connection.new
        @response = conn.get @search_url
      end

      def self.search_url_fragment
        "search"
      end

      def self.parameterize_params
        query_hsh = @args.merge({scope: @scope})
        arr = []
        query_hsh.each_pair { |q,v|
          arr << "#{q}=#{v}"
        }
        arr.join("&")
      end

      def self.chk_search_args
        string_keys?
        incoming_keys = @args.keys.sort
        compare_keys(incoming_keys,@required_keys)
      end

      def self.string_keys?
        string_keys = []
        @args.keys.each { |k|
          string_keys << k unless k.is_a?(Symbol)
        }
        raise ArgumentError.new("Param key: #{string_keys} should be of type Symbol") if string_keys.size > 0
      end
      def self.compare_keys(incoming_keys, required_keys)
        unless required_keys.empty?
          compare_keys = incoming_keys - required_keys
          raise ArgumentError.new("Required params: #{required_keys}") unless compare_keys.empty?
        end
      end

      def self.is_valid?
        case @hsh.class.to_s
        when "Hash"
          incoming_keys = @hsh.keys.sort
          compare_keys(incoming_keys,hsh_valid_keys)
        else
          raise ArgumentError.new("Expecting hash as a arguments with the following arguments: #{hsh_valid_keys}")
        end
      end

      def self.hsh_valid_keys
        [:params, :required_params, :scope].sort
      end

      private_class_method :chk_search_args, :compare_keys, :hsh_valid_keys, :is_valid?, :query_search_url, :parameterize_params, :search_url_fragment, :query, :string_keys?
    end
  end
end
