module Blurb
  class AdGroup < BaseResource

    URL_PARAMS = ['startIndex', 'campaignType', 'count', 'matchTypeFilter', 'name', 'state', 'campaignIdFilter', 'adGroupIdFilter']

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
      get_request("/v2/#{campaign_type}/adGroups?#{setup_url_params(params, URL_PARAMS)}")
    end

    def list_extended(campaign_type, params = {}, opts = {})
      raise ArgumentError.new("adGroups interface is only supported for Sponsored Products") unless campaign_type == SPONSORED_PRODUCTS
      get_request("/v2/#{campaign_type}/adGroups/extended?#{setup_url_params(params, URL_PARAMS)}")
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
  end
end
