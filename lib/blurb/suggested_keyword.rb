module Blurb
  class SuggestedKeyword < BaseResource
    URL_PARAMS = ['maxNumSuggestions', 'adStateFilter', 'suggestBids']

    def ad_group_suggestions(params = {}, opts = {})
      # required argument checks
      raise ArgumentError.new("params hash must contain an adGroupId") unless params["adGroupId"]

      get_request("/v2/adGroups/#{params["adGroupId"]}/suggested/keywords?#{setup_url_params(params, URL_PARAMS)}")
    end

    def ad_group_extended_suggestions(params = {}, opts = {})
      # required argument checks
      raise ArgumentError.new("params hash must contain an adGroupId") unless params["adGroupId"]

      get_request("/v2/adGroups/#{params["adGroupId"]}/suggested/keywords/extended?#{setup_url_params(params, URL_PARAMS)}")
    end

    def asin_suggestions(params = {}, opts = {})
      # required argument checks
      raise ArgumentError.new("params hash must contain an asinValue") unless params["asinValue"]

      get_request("/v2/asins/#{params["asinValue"]}/suggested/keywords?#{setup_url_params(params, URL_PARAMS)}")
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
  end
end
