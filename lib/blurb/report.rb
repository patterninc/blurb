module Blurb
  class Report < BaseResource
    CAMPAIGNS = "campaigns"
    AD_GROUPS = "adGroups"
    KEYWORDS = "keywords"
    PRODUCT_ADS = "productAds"
    SPONSORED_PRODUCTS = "sp"
    SPONSORED_BRANDS = "hsa"

    def self.create(params = {}, opts = {})
      # required argument checks
      raise ArgumentError.new("params hash must contain a recordType") unless params["recordType"]

      api_params = {
        "reportDate" => params["reportDate"],
        "metrics" => params["metrics"]
      }

      api_params["segment"] = params["segment"] if params["segment"]

      post_request("/v2/#{campaignType}/#{params["recordType"]}/report", api_params)
    end

    def self.status(report_id, opts = {})
      get_request("/v2/reports/#{report_id}")
    end

    def self.download(location, opts = {})
      opts.merge!({:full_path => true, :gzip => true, :no_token => true})
      get_request(location, opts)
    end
  end
end
