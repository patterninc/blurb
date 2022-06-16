require 'blurb/request_collection_with_campaign_type'

class Blurb
  class ReportRequests < RequestCollectionWithCampaignType

    def initialize(campaign_type:, base_url:, headers:)
      @campaign_type = campaign_type
      @base_url = "#{base_url}/v2/#{@campaign_type}"
      @headers = headers
      @tactic = "T00020"
    end

    def create(
      record_type:,
      report_date:,
      metrics: nil,
      segment: nil,
      creative_type: nil,
      tactic: nil
    )
      # create payload
      metrics = get_default_metrics(record_type.to_s.underscore.to_sym, segment) if metrics.nil?
      @tactic = tactic if !tactic.nil?
      payload = {
        metrics: metrics.map{ |m| m.to_s.camelize(:lower) }.join(","),
        report_date: report_date
      }
      payload[:segment] = segment if segment
      payload[:tactic] = @tactic if @campaign_type.to_sym == :sd
      payload[:creative_type] = creative_type if creative_type

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

    def get_default_metrics(record_type, segment = nil)
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
        ] if record_type == :keywords && segment.nil?
        return [
          "adGroupId",
          "campaignId",
          "impressions",
          "clicks",
          "cost",
          "attributedSales14d",
          "attributedConversions14d",
        ] if record_type == :keywords && segment.present?
      elsif @campaign_type == CAMPAIGN_TYPE_CODES[:sp]
        return [
          "campaignId",
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
          "campaignId",
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
          "campaignId",
          "keywordId",
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
          "campaignId",
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
        ] if record_type == :product_ads
        return [
          "campaignId",
          "targetId",
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
          "campaignId",
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
        ] if record_type == :portfolios
      elsif @campaign_type == CAMPAIGN_TYPE_CODES[:sd]
        return [
          "campaignId",
          "impressions",
          "clicks",
          "cost",
          "currency",
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
          "campaignId",
          "adGroupId",
          "impressions",
          "clicks",
          "cost",
          "currency",
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
          "campaignId",
          "adGroupId",
          "impressions",
          "clicks",
          "cost",
          "currency",
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
          "campaignId",
          "targetId",
          "impressions",
          "clicks",
          "cost",
          "currency",
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
      end
    end
  end
end
