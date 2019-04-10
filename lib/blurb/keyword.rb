module Blurb
  class Keyword < BaseResource
    URL_PARAMS = ['startIndex', 'count', 'matchTypeFilter', 'keywordText', 'state', 'campaignIdFilter', 'adGroupIdFilter']

    def retrieve(keyword_id, campaign_type)
      get_request("/v2/#{campaign_type}/keywords/#{keyword_id}")
    end

    def retrieve_extended(keyword_id, campaign_type)
      raise ArgumentError.new("Extended keywords interface is only supported for Sponsored Products") unless campaign_type == SPONSORED_PRODUCTS
      get_request("/v2/#{campaign_type}/keywords/extended/#{keyword_id}")
    end

    def list(campaign_type, params = {}, opts = {})
      get_request("/v2/#{campaign_type}/keywords?#{setup_url_params(params, URL_PARAMS)}")
    end

    def list_extended(campaign_type, params = {}, opts = {})
      raise ArgumentError.new("Extended keywords interface is only supported for Sponsored Products") unless campaign_type == SPONSORED_PRODUCTS
      get_request("/v2/#{campaign_type}/keywords/extended?#{setup_url_params(params, URL_PARAMS)}")
    end

    def update(campaign_type, payload, opts = {})
      raise ArgumentError.new("Extended keywords interface is only supported for Sponsored Products") unless campaign_type == SPONSORED_PRODUCTS
      payload = [payload] unless payload.class == Array

      # The Amazon Advertising API only accepts bulk changes of up to 1000 keywords
      results = []
      payloads = payload.each_slice(1000).to_a
      payloads.each do |p|
        results << put_request("/v2/#{campaign_type}/keywords", p)
      end

      return results.flatten
    end

    def create(campaign_type, params = {}, opts = {})
      # required argument checks
      if !params["campaignId"] && !params["adGroupId"] && !params["keywordText"] && !params["matchType"] && !params["state"]
        raise ArgumentError.new("params hash must contain campaignId, adGroupId, keywordText, matchType and state")
      end
      raise ArgumentError.new("Only sponsored product keywords can be created through the api.  Sponsored Brands keywords must be created through the user interface") unless campaign_type == SPONSORED_PRODUCTS

      post_request("/v2/#{campaign_type}/keywords", [params])
    end

    def delete(keyword_id)
      delete_request("/v2/keywords/#{keyword_id}")
    end
  end
end
