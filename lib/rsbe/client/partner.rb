require 'faraday'

module Rsbe
  module Client
    class Partner < Base
      def initialize
        @path = 'partners'
      end
    end
  end
end
