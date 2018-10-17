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

      # If no metrics are passed in, use the default metrics
      metrics = params["metrics"] || get_default_metrics(params["recordType"],params["campaignType"])
      puts "\nMetrics: #{metrics}"

      api_params = {
        "reportDate" => params["reportDate"],
        "metrics" => metrics
      }

      api_params["segment"] = params["segment"] if params["segment"]

      post_request("/v2/#{params["campaignType"]}/#{params["recordType"]}/report", api_params)
    end

    def self.status(report_id, opts = {})
      get_request("/v2/reports/#{report_id}")
    end

    def self.download(location, opts = {})
      opts.merge!({:full_path => true, :gzip => true, :no_token => true})
      get_request(location, opts)
    end

    private

    def self.get_default_metrics(record_type, campaign_type)
      metrics = [
        "campaignName",
        "campaignId",
        "impressions",
        "clicks",
        "cost",
        "attributedSales14d",
        "attributedSales14dSameSKU",
        "attributedConversions14d",
        "attributedConversions14dSameSKU"
      ]

      metrics.push(
        "attributedConversions1d",
        "attributedConversions7d",
        "attributedConversions14d",
        "attributedConversions30d",
        "attributedConversions1dSameSKU",
        "attributedConversions7dSameSKU",
        "attributedConversions30dSameSKU",
        "attributedUnitsOrdered1d",
        "attributedUnitsOrdered7d",
        "attributedUnitsOrdered30d",
        "attributedSales1d",
        "attributedSales7d",
        "attributedSales30d",
        "attributedSales1dSameSKU",
        "attributedSales7dSameSKU",
        "attributedSales30dSameSKU"
      ) if campaign_type == SPONSORED_PRODUCTS

      metrics.push(
        "adGroupName",
        "adGroupId"
      ) if record_type == AD_GROUPS

      metrics.push(
        "campaignStatus",
        "campaignBudget"
      ) if record_type == CAMPAIGNS

      metrics.push(
        "campaignBudgetType"
      ) if record_type == CAMPAIGNS && campaign_type = SPONSORED_BRANDS

      metrics.push(
        "adGroupName",
        "adGroupId",
        "currency",
        "asin",
        "sku"
      ) if record_type == PRODUCT_ADS

      metrics.push(
        "keywordId",
        "keywordText",
        "matchType"
      ) if record_type == KEYWORDS

      return metrics.join(",")
    end
  end
end
