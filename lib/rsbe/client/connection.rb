require 'faraday'

module Rsbe
  module Client
    class Connection
      extend Forwardable
      def_delegators :@conn, :get, :put, :post, :delete, :patch

      def new
        @user     = ENV['RSBE_USER']     || 'foo'
        @password = ENV['RSBE_PASSWORD'] || 'bar'
        @url      = ENV['RSBE_URL']      || 'http://localhost:3000'
        @conn     = Faraday.new(url: @url) do |faraday|
          faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
        end
        @conn.basic_auth(@user, @password)
      end
      PATH = '/api/v0'
    end
  end
end
