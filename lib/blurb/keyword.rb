module Blurb
  class Keyword < BaseResource
    SPONSORED_PRODUCTS = "sp"
    SPONSORED_BRANDS = "hsa"

    def retrieve(keyword_id, campaign_type)
      get_request("/v2/#{campaign_type}/keywords/#{keyword_id}")
    end

    def retrieve_extended(keyword_id, campaign_type)
      raise ArgumentError.new("Extended keywords interface is only supported for Sponsored Products") unless campaign_type == SPONSORED_PRODUCTS
      get_request("/v2/#{campaign_type}/keywords/extended/#{keyword_id}")
    end

    def list(campaign_type, params = {}, opts = {})
      get_request("/v2/#{campaign_type}/keywords?#{setup_url_params(params)}")
    end

    def list_extended(campaign_type, params = {}, opts = {})
      raise ArgumentError.new("Extended keywords interface is only supported for Sponsored Products") unless campaign_type == SPONSORED_PRODUCTS
      get_request("/v2/#{campaign_type}/keywords/extended?#{setup_url_params(params)}")
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

    private

    def setup_url_params(params)
      url_params = ""
      url_params = "startIndex=#{params['startIndex']}" if params['startIndex']

      if params['count']
        url_params += "&" if url_params.size > 0
        url_params += "count=#{params['count']}"
      end

      if params['campaignType']
        url_params += "&" if url_params.size > 0
        url_params += "campaignType=#{params['campaignType']}"
      end

      if params['matchTypeFilter']
        url_params += "&" if url_params.size > 0
        url_params += "matchTypeFilter=#{params['matchTypeFilter']}"
      end

      if params['keywordText']
        url_params += "&" if url_params.size > 0
        url_params += "keywordText=#{params['keywordText']}"
      end

      if params['state']
        url_params += "&" if url_params.size > 0
        url_params += "state=#{params['state']}"
      end

      if params['campaignIdFilter']
        url_params += "&" if url_params.size > 0
        url_params += "campaignIdFilter=#{params['campaignIdFilter']}"
      end

      if params['adGroupIdFilter']
        url_params += "&" if url_params.size > 0
        url_params += "adGroupIdFilter=#{params['adGroupIdFilter']}"
      end

      return url_params
    end
  end
end
