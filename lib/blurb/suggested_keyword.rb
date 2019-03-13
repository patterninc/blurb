module Blurb
  class SuggestedKeyword < BaseResource
    def ad_group_suggestions(params = {}, opts = {})
      # required argument checks
      raise ArgumentError.new("params hash must contain an adGroupId") unless params["adGroupId"]

      get_request("/v2/adGroups/#{params["adGroupId"]}/suggested/keywords?#{setup_url_params(params)}")
    end

    def ad_group_extended_suggestions(params = {}, opts = {})
      # required argument checks
      raise ArgumentError.new("params hash must contain an adGroupId") unless params["adGroupId"]

      get_request("/v2/adGroups/#{params["adGroupId"]}/suggested/keywords/extended?#{setup_url_params(params)}")
    end

    def asin_suggestions(params = {}, opts = {})
      # required argument checks
      raise ArgumentError.new("params hash must contain an asinValue") unless params["asinValue"]

      get_request("/v2/asins/#{params["asinValue"]}/suggested/keywords?#{setup_url_params(params)}")
    end

    def bulk_asin_suggestions(params = {}, opts = {})
      # required argument checks
      raise ArgumentError.new("params hash must contain an asins array") unless params["asins"]

      maxNumSuggestions = 100
      maxNumSuggestions = params["maxNumSuggestions"] if params["maxNumSuggestions"]

      post_request("/v2/asins/suggested/keywords", {
        "asins" => params["asins"],
        "maxNumSuggestions" => maxNumSuggestions
      })
    end

    private

    def setup_url_params(params)
      url_params = ""
      url_params = "maxNumSuggestions=#{params['maxNumSuggestions']}" if params['maxNumSuggestions']

      if params['adStateFilter']
        url_params += "&" if url_params.size > 0
        url_params += "adStateFilter=#{params['adStateFilter']}"
      end

      if params['suggestBids']
        url_params += "&" if url_params.size > 0
        url_params += "suggestBids=#{params['suggestBids']}"
      end

      return url_params
    end
  end
end
