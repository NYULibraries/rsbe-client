module Rsbe
  module Client
    class SearchResults
      def initialize(response)
        @response = response
        @json     = JSON.parse(@response.body)
      end

      def success?
        @response.status == 200
      end

      def num_found
        @json['response']['numFound']
      end
    end
  end
end
