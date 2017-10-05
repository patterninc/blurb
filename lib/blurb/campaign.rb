module Blurb
  class Campaign < BaseResource
    def self.retrieve(campaign_id)
      get_request("/v1/campaigns/#{campaign_id}")
    end

    def self.retrieve_extended(campaign_id)
      get_request("/v1/campaigns/extended/#{campaign_id}")
    end

    def self.list(params = {}, opts = {})
      get_request("/v1/campaigns?#{setup_url_params(params)}")
    end

    def self.create(params = {}, opts = {})
      # required argument checks
      if !params["name"] && !params["campaignType"] && !params["targetingType"] && !params["state"] && !params["dailyBudget"] && !params["startDate"]
        raise ArgumentError.new("params hash must contain name, campaignType, targetingType, state, dailyBudget and startDate")
      end

      post_request("/v1/campaigns", [params])
    end

    def self.create_bulk(campaign_array, opts = {})
      post_request("/v1/campaigns", campaign_array)
    end

    private

    def self.setup_url_params(params)
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
