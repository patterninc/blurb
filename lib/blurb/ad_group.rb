module Blurb
  class AdGroup < BaseResource
    SPONSORED_PRODUCTS = "sp"
    SPONSORED_BRANDS = "hsa"

    def retrieve(keyword_id, campaign_type)
      raise ArgumentError.new("adGroups interface is only supported for Sponsored Products") unless campaign_type == SPONSORED_PRODUCTS
      get_request("/v2/#{campaign_type}/adGroups/#{keyword_id}")
    end

    def retrieve_extended(keyword_id, campaign_type)
      raise ArgumentError.new("adGroups interface is only supported for Sponsored Products") unless campaign_type == SPONSORED_PRODUCTS
      get_request("/v2/#{campaign_type}/adGroups/extended/#{keyword_id}")
    end

    def list(campaign_type, params = {}, opts = {})
      raise ArgumentError.new("adGroups interface is only supported for Sponsored Products") unless campaign_type == SPONSORED_PRODUCTS
      get_request("/v2/#{campaign_type}/adGroups?#{setup_url_params(params)}")
    end

    def list_extended(campaign_type, params = {}, opts = {})
      raise ArgumentError.new("adGroups interface is only supported for Sponsored Products") unless campaign_type == SPONSORED_PRODUCTS
      get_request("/v2/#{campaign_type}/adGroups/extended?#{setup_url_params(params)}")
    end

    def create(campaign_type, params = {}, opts = {})
      # required argument checks
      if !params["name"] && !params["targetingType"] && !params["state"] && !params["dailyBudget"] && !params["startDate"]
        raise ArgumentError.new("params hash must contain name, targetingType, state, dailyBudget and startDate")
      end
      raise ArgumentError.new("Only sponsored product adGroups can be created through the api.  Sponsored Brands adGroups must be created through the user interface") unless campaign_type == SPONSORED_PRODUCTS

      post_request("/v2/#{campaign_type}/adGroups", [params])
    end

    def delete(keyword_id)
      delete_request("/v2/adGroups/#{keyword_id}")
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

      if params['name']
        url_params += "&" if url_params.size > 0
        url_params += "name=#{params['name']}"
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
