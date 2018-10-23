module Blurb
  class Campaign < BaseResource
    SPONSORED_PRODUCTS = "sp"
    SPONSORED_BRANDS = "hsa"

    def self.retrieve(campaign_id, campaign_type)
      get_request("/v2/#{campaign_type}/campaigns/#{campaign_id}")
    end

    def self.retrieve_extended(campaign_id, campaign_type)
      get_request("/v2/#{campaign_type}/campaigns/extended/#{campaign_id}")
    end

    def self.list(campaign_type, params = {}, opts = {})
      get_request("/v2/#{campaign_type}/campaigns?#{setup_url_params(params)}")
    end

    def self.create(campaign_type, params = {}, opts = {})
      # required argument checks
      if !params["name"] && !params["targetingType"] && !params["state"] && !params["dailyBudget"] && !params["startDate"]
        raise ArgumentError.new("params hash must contain name, targetingType, state, dailyBudget and startDate")
      end
      raise ArgumentError.new("Only sponsored product campaigns can be created through the api.  Sponsored Brands campaigns must be created through the user interface") unless campaign_type = SPONSORED_PRODUCTS

      post_request("/v2/#{campaign_type}/campaigns", [params])
    end

    # Deprecated in v2
    # def self.create_bulk(campaign_array, opts = {})
    #   post_request("/v1/campaigns", campaign_array)
    # end

    private

    def self.setup_url_params(params)
      url_params = ""
      url_params = "startIndex=#{params['startIndex']}" if params['startIndex']

      if params['count']
        url_params += "&" if url_params.size > 0
        url_params += "count=#{params['count']}"
      end

      if params['stateFilter']
        url_params += "&" if url_params.size > 0
        url_params += "stateFilter=#{params['stateFilter']}"
      end

      if params['name']
        url_params += "&" if url_params.size > 0
        url_params += "name=#{params['name']}"
      end

      if params['campaignIdFilter']
        url_params += "&" if url_params.size > 0
        url_params += "campaignIdFilter=#{params['campaignIdFilter']}"
      end

      return url_params
    end
  end
end
