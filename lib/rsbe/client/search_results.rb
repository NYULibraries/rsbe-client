module Rsbe
  module Client
    class SearchResults
      def initialize(api_response)
        @api_response = api_response
        # init json
        json
      end

      def success?
        @api_response.status == 200
      end

      def num_found
        response['numFound']
      end

      def results
        @results ||= urls.collect {|u| Rsbe::Client.find(u)}
      end

      private

      def response
        @response ||= json['response']
      end

      def json
        @json ||= JSON.parse(@api_response.body)
      end

      def docs
        @docs ||= response['docs']
      end

      def urls
        @urls ||= docs.collect {|d| d['url']}
      end
    end
  end
end
