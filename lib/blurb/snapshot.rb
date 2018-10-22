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

      post_request("/v2/#{params["recordType"]}/snapshot", {
        "campaignType" => "sponsoredProducts",
        "stateFilter" => params["stateFilter"]
      })
    end

    def self.status(snapshot_id, opts = {})
      get_request("/v2/snapshots/#{snapshot_id}")
    end

    def self.download(location, opts = {})
      opts.merge!({:full_path => true, :gzip => true, :no_token => true})
      get_request(location, opts)
    end
  end
end
