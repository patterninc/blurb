module Blurb
  class Campaign < BaseResource

    URL_PARAMS = ['count', 'stateFilter', 'startIndex', 'name', 'campaignIdFilter']

    def retrieve(campaign_id, campaign_type)
      get_request("/v2/#{campaign_type}/campaigns/#{campaign_id}")
    end

    def retrieve_extended(campaign_id, campaign_type)
      raise ArgumentError.new("Extended campaigns interface is only supported for Sponsored Products") unless campaign_type == SPONSORED_PRODUCTS
      get_request("/v2/#{campaign_type}/campaigns/extended/#{campaign_id}")
    end

    def list(campaign_type, params = {}, opts = {})
      get_request("/v2/#{campaign_type}/campaigns?#{setup_url_params(params, URL_PARAMS)}")
    end

    def list_extended(campaign_type, params = {}, opts = {})
      raise ArgumentError.new("Extended campaigns interface is only supported for Sponsored Products") unless campaign_type == SPONSORED_PRODUCTS
      get_request("/v2/#{campaign_type}/campaigns/extended?#{setup_url_params(params, URL_PARAMS)}")
    end

    def create(campaign_type, params = {}, opts = {})
      # required argument checks
      if !params["name"] && !params["targetingType"] && !params["state"] && !params["dailyBudget"] && !params["startDate"]
        raise ArgumentError.new("params hash must contain name, targetingType, state, dailyBudget and startDate")
      end
      raise ArgumentError.new("Only sponsored product campaigns can be created through the api.  Sponsored Brands campaigns must be created through the user interface") unless campaign_type == SPONSORED_PRODUCTS

      post_request("/v2/#{campaign_type}/campaigns", [params])
    end

    def delete(campaign_id)
      delete_request("/v2/campaigns/#{campaign_id}")
    end
  end
end
