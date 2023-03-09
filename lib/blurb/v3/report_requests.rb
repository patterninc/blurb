# frozen_string_literal: true

require 'blurb/request_collection'

class Blurb
  module V3
    # Adapter for ADS v3 report requests
    class ReportRequests < RequestCollection
      def initialize(headers:, base_url:, bulk_api_limit: 100)
        super
        @base_url = "#{base_url}/reporting/reports"
      end

      def create(name:, start_date:, end_date:, configuration: {})
        execute_request(
          request_type: :post,
          payload: {
            name: name,
            startDate: start_date,
            endDate: end_date,
            configuration: configuration
          }
        )
      end
    end
  end
end
