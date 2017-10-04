module Blurb
  class BidRecommendation < BaseResource
    def self.ad_group_recommendations(params = {}, opts = {})
      # required argument checks
      raise ArgumentError.new("params hash must contain an adGroupId") unless params["adGroupId"]

      get_request("/v1/adGroups/#{params["adGroupId"]}/bidRecommendations")
    end

    def self.keyword_recommendations(params = {}, opts = {})
      # required argument checks
      raise ArgumentError.new("params hash must contain an keywordId") unless params["keywordId"]

      get_request("/v1/keywords/#{params["keywordId"]}/bidRecommendations")
    end

    def self.bulk_keyword_recommendations(params = {}, opts = {})
      # required argument checks
      raise ArgumentError.new("params hash must contain an array of keywordIds") unless params["keywordIds"]

      post_request("/v1/keywords/bidRecommendations", params["keywordIds"])
    end
  end
end
