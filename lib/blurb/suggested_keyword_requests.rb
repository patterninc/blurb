require 'blurb/request'

class Blurb
  class SuggestedKeywordRequests
    def initialize(base_url:, headers:)
      @base_url = base_url
      @headers = headers
    end

    def ad_group_retrieve(ad_group_id)
      execute_request(
        api_path: "/adGroups/#{ad_group_id}/suggested/keywords",
        request_type: :get
      )
    end

    def ad_group_retrieve_extended(ad_group_id)
      execute_request(
        api_path: "/adGroups/#{ad_group_id}/suggested/keywords/extended",
        request_type: :get
      )
    end

    def asin_retrieve(asin_value)
      execute_request(
        api_path: "/asins/#{asin_value}/suggested/keywords",
        request_type: :get
      )
    end

    # TODO: Implement later
    # def asin_list(asin_list)
    #   execute_request(
    #     api_path: '/asins/suggested/keywords',
    #     request_type: :post,
    #     payload: asin_list
    #   )
    # end

    private

    def execute_request(api_path: "", request_type:, payload: nil, url_params: nil)
      url = "#{@base_url}#{api_path}"

      request = Request.new(
        url: url,
        url_params: url_params,
        request_type: request_type,
        payload: payload,
        headers: @headers
      )

      request.make_request
    end
  end
end