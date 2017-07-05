module Rsbe
  module Client
    class SearchResults
      def initialize(response)
        @response = response
      end

      def success?
        @response.status == 200
      end
    end
  end
end
