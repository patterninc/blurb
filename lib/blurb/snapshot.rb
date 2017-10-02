module Blurb
  class Snapshot < BaseResource
    CAMPAIGNS = "campaigns"
    AD_GROUPS = "adGroups"
    KEYWORDS = "keywords"
    NEGATIVE_KEYWORDS = "negativeKeywords"
    CAMPAIGN_NEGATIVE_KEYWORDS = "campaignNegativeKeywords"
    PRODUCT_ADS = "productAds"

    def self.create(params = {}, opts = {})
      # required argument checks
      raise ArgumentError.new("params hash must contain a recordType") unless params["recordType"]

      post_request("/v1/#{params["recordType"]}/snapshot", {
        "campaignType" => "sponsoredProducts",
        "stateFilter" => params["stateFilter"]
      })
    end
  end
end
