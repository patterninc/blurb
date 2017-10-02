module Blurb
  class Report < BaseResource
    CAMPAIGNS = "campaigns"
    AD_GROUPS = "adGroups"
    KEYWORDS = "keywords"
    PRODUCT_ADS = "productAds"

    def self.create(params = {}, opts = {})
      # required argument checks
      raise ArgumentError.new("params hash must contain a recordType") unless params["recordType"]

      post_request("/v1/#{params["recordType"]}/report", {
        "campaignType" => "sponsoredProducts",
        "segment" => "query",
        "reportDate" => params["reportDate"],
        "metrics" => params["metrics"]
      })
    end

    def self.status(report_id, opts = {})
      get_request("/v1/reports/#{report_id}")
    end

    def self.download(location, opts = {})
      opts.merge!({:full_path => true, :gzip => true, :no_token => true})
      get_request(location, opts)
    end
  end
end
