require 'blurb/request_collection'

class Blurb
  class InvoiceRequest < RequestCollection
    def initialize(base_url:, headers:)
      super(base_url: base_url, headers: headers)
    end

    def retrieve(report_id)
      execute_request(
        api_path: "/#{report_id}",
        request_type: :get
      )
    end
  end
end
