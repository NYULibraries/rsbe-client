require 'faraday'
require 'json'

module Rsbe
  module Client
    class Base
      def initialize
        @conn = Rsbe::Client::Connection.new
      end
      def base_path
        '/api/v0'
      end
    end
  end
end
