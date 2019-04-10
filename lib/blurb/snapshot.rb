module Blurb
  class Snapshot < BaseResource
    CAMPAIGNS = "campaigns"
    AD_GROUPS = "adGroups"
    KEYWORDS = "keywords"
    NEGATIVE_KEYWORDS = "negativeKeywords"
    CAMPAIGN_NEGATIVE_KEYWORDS = "campaignNegativeKeywords"
    PRODUCT_ADS = "productAds"
    TARGETS = "targets"

    def create(params = {}, opts = {})
      # required argument checks
      raise ArgumentError.new("params hash must contain a recordType") unless params["recordType"]

      # Default State Filter if no params passed in
      state_filter = params["stateFilter"] || "enabled,paused"

      # Default campaign type so version 2.3 is backward compatible with version 2.2
      campaign_type = params["campaignType"] || SPONSORED_PRODUCTS

      post_request("/v2/#{campaign_type}/#{params["recordType"]}/snapshot", {
        "stateFilter" => state_filter
      })
    end

    def status(snapshot_id, opts = {})
      get_request("/v2/snapshots/#{snapshot_id}")
    end

    def download(location, opts = {})
      opts.merge!({:full_path => true, :gzip => true, :no_token => true})
      get_request(location, opts)
    end
  end
end
