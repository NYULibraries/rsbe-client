require 'faraday'
require 'json'

module Rsbe
  module Client
    class Base
      def initialize
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
