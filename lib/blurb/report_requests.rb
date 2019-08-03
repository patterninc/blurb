require 'blurb/request_collection_with_campaign_type'

class ReportRequests < RequestCollectionWithCampaignType
  def initialize(campaign_type:, base_url:, headers:)
    @campaign_type = campaign_type
    @base_url = "#{base_url}/v2/#{@campaign_type}"
    @headers = headers
  end

  def create(
    record_type:,
    report_date: Date.today,
    metrics: nil,
    segment: nil
  )
    # create payload
    metrics = get_default_metrics(record_type) if metrics.nil?
    payload = {
      metrics: metrics.map{ |m| m.to_s.camelize(:lower) }.join(","),
      report_date: report_date
    }
    payload[:segment] = segment if segment

    execute_request(
      api_path: "/#{record_type.to_s.camelize(:lower)}/report",
      request_type: :post,
      payload: payload
    )
  end

  def retrieve(report_id)
    execute_request(
      api_path: "/reports/#{report_id}",
      request_type: :get,
    )
  end

  def download(report_id)
    execute_request(
      api_path: "/reports/#{report_id}/download",
      request_type: :get,
    )
  end

  private

  def get_default_metrics(record_type)
    if @campaign_type == CAMPAIGN_TYPE_CODES[:sb]
      return [
        "campaignId",
        "impressions",
        "clicks",
        "cost",
        "attributedSales14d",
        "attributedSales14dSameSKU",
        "attributedConversions14d",
        "attributedConversions14dSameSKU"
      ] if record_type == :campaigns
      return [
        "adGroupId",
        "campaignId",
        "impressions",
        "clicks",
        "cost",
        "attributedSales14d",
        "attributedSales14dSameSKU",
        "attributedConversions14d",
        "attributedConversions14dSameSKU"
      ] if record_type == :ad_groups
      return [
        "keywordId",
        "adGroupId",
        "campaignId",
        "impressions",
        "clicks",
        "cost",
        "attributedSales14d",
        "attributedSales14dSameSKU",
        "attributedConversions14d",
        "attributedConversions14dSameSKU"
      ] if record_type == :keywords
    elsif @campaign_type == CAMPAIGN_TYPE_CODES[:sp]
      return [
        "campaignName",
        "campaignId",
        "campaignStatus",
        "campaignBudget",
        "impressions",
        "clicks",
        "cost",
        "attributedConversions1d",
        "attributedConversions7d",
        "attributedConversions14d",
        "attributedConversions30d",
        "attributedConversions1dSameSKU",
        "attributedConversions7dSameSKU",
        "attributedConversions14dSameSKU",
        "attributedConversions30dSameSKU",
        "attributedUnitsOrdered1d",
        "attributedUnitsOrdered7d",
        "attributedUnitsOrdered14d",
        "attributedUnitsOrdered30d",
        "attributedSales1d",
        "attributedSales7d",
        "attributedSales14d",
        "attributedSales30d",
        "attributedSales1dSameSKU",
        "attributedSales7dSameSKU",
        "attributedSales14dSameSKU",
        "attributedSales30dSameSKU"
      ] if record_type == :campaigns
      return [
        "campaignName",
        "campaignId",
        "adGroupName",
        "adGroupId",
        "impressions",
        "clicks",
        "cost",
        "attributedConversions1d",
        "attributedConversions7d",
        "attributedConversions14d",
        "attributedConversions30d",
        "attributedConversions1dSameSKU",
        "attributedConversions7dSameSKU",
        "attributedConversions14dSameSKU",
        "attributedConversions30dSameSKU",
        "attributedUnitsOrdered1d",
        "attributedUnitsOrdered7d",
        "attributedUnitsOrdered14d",
        "attributedUnitsOrdered30d",
        "attributedSales1d",
        "attributedSales7d",
        "attributedSales14d",
        "attributedSales30d",
        "attributedSales1dSameSKU",
        "attributedSales7dSameSKU",
        "attributedSales14dSameSKU",
        "attributedSales30dSameSKU"
      ] if record_type == :ad_groups
      return [
        "campaignName",
        "campaignId",
        "keywordId",
        "keywordText",
        "matchType",
        "impressions",
        "clicks",
        "cost",
        "attributedConversions1d",
        "attributedConversions7d",
        "attributedConversions14d",
        "attributedConversions30d",
        "attributedConversions1dSameSKU",
        "attributedConversions7dSameSKU",
        "attributedConversions14dSameSKU",
        "attributedConversions30dSameSKU",
        "attributedUnitsOrdered1d",
        "attributedUnitsOrdered7d",
        "attributedUnitsOrdered14d",
        "attributedUnitsOrdered30d",
        "attributedSales1d",
        "attributedSales7d",
        "attributedSales14d",
        "attributedSales30d",
        "attributedSales1dSameSKU",
        "attributedSales7dSameSKU",
        "attributedSales14dSameSKU",
        "attributedSales30dSameSKU"
      ] if record_type == :keywords
      return [
        "campaignName",
        "campaignId",
        "adGroupName",
        "adGroupId",
        "impressions",
        "clicks",
        "cost",
        "currency",
        "asin",
        "sku",
        "attributedConversions1d",
        "attributedConversions7d",
        "attributedConversions14d",
        "attributedConversions30d",
        "attributedConversions1dSameSKU",
        "attributedConversions7dSameSKU",
        "attributedConversions14dSameSKU",
        "attributedConversions30dSameSKU",
        "attributedUnitsOrdered1d",
        "attributedUnitsOrdered7d",
        "attributedUnitsOrdered14d",
        "attributedUnitsOrdered30d",
        "attributedSales1d",
        "attributedSales7d",
        "attributedSales14d",
        "attributedSales30d",
        "attributedSales1dSameSKU",
        "attributedSales7dSameSKU",
        "attributedSales14dSameSKU",
        "attributedSales30dSameSKU"
      ] if record_type == :product_ads
      return [
        "campaignName",
        "campaignId",
        "targetId",
        "targetingExpression",
        "targetingText",
        "targetingType",
        "impressions",
        "clicks",
        "cost",
        "attributedConversions1d",
        "attributedConversions7d",
        "attributedConversions14d",
        "attributedConversions30d",
        "attributedConversions1dSameSKU",
        "attributedConversions7dSameSKU",
        "attributedConversions14dSameSKU",
        "attributedConversions30dSameSKU",
        "attributedUnitsOrdered1d",
        "attributedUnitsOrdered7d",
        "attributedUnitsOrdered14d",
        "attributedUnitsOrdered30d",
        "attributedSales1d",
        "attributedSales7d",
        "attributedSales14d",
        "attributedSales30d",
        "attributedSales1dSameSKU",
        "attributedSales7dSameSKU",
        "attributedSales14dSameSKU",
        "attributedSales30dSameSKU"
      ] if record_type == :targets
      return [
        "campaignName",
        "campaignId",
        "adGroupName",
        "adGroupId",
        "impressions",
        "clicks",
        "cost",
        "currency",
        "asin",
        "sku",
        "attributedConversions1d",
        "attributedConversions7d",
        "attributedConversions14d",
        "attributedConversions30d",
        "attributedConversions1dSameSKU",
        "attributedConversions7dSameSKU",
        "attributedConversions14dSameSKU",
        "attributedConversions30dSameSKU",
        "attributedUnitsOrdered1d",
        "attributedUnitsOrdered7d",
        "attributedUnitsOrdered14d",
        "attributedUnitsOrdered30d",
        "attributedSales1d",
        "attributedSales7d",
        "attributedSales14d",
        "attributedSales30d",
        "attributedSales1dSameSKU",
        "attributedSales7dSameSKU",
        "attributedSales14dSameSKU",
        "attributedSales30dSameSKU"
      ] if record_type == :portfolios
    end
  end
end
