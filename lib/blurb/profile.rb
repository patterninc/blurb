require "blurb/account"
require "blurb/campaign_requests"
require "blurb/snapshot_requests"
require "blurb/report_requests"
require "blurb/report_requests_v3"
require "blurb/request_collection"
require "blurb/request_collection_with_campaign_type"
require "blurb/suggested_keyword_requests"
require "blurb/history_request"
require "blurb/invoice_request"

class Blurb
  class Profile < BaseClass

    attr_accessor(
      :account,
      :ad_groups,
      :sd_ad_groups,
      :campaign_negative_keywords,
      :portfolios,
      :product_ads,
      :sd_product_ads,
      :profile_id,
      :suggested_keywords,
      :targets,
      :history,
      :invoices
    )

    def initialize(profile_id:, account:)
      @profile_id = profile_id
      @account = account

      @sp_campaigns = CampaignRequests.new(
        headers: headers_hash,
        base_url: @account.api_url,
        resource: "campaigns",
        campaign_type: CAMPAIGN_TYPE_CODES[:sp]
      )
      @sb_campaigns = CampaignRequests.new(
        headers: headers_hash,
        base_url: @account.api_url,
        resource: "campaigns",
        campaign_type: CAMPAIGN_TYPE_CODES[:sb],
        bulk_api_limit: 10
      )
      @sd_campaigns = CampaignRequests.new(
        headers: headers_hash,
        base_url: @account.api_url,
        resource: "campaigns",
        campaign_type: CAMPAIGN_TYPE_CODES[:sd],
        bulk_api_limit: 10
      )
      @sp_keywords = RequestCollectionWithCampaignType.new(
        headers: headers_hash,
        base_url: @account.api_url,
        resource: "keywords",
        campaign_type: CAMPAIGN_TYPE_CODES[:sp]
      )
      @sb_keywords = RequestCollectionWithCampaignType.new(
        headers: headers_hash,
        base_url: @account.api_url,
        resource: "keywords",
        campaign_type: CAMPAIGN_TYPE_CODES[:sb]
      )
      @sp_snapshots = SnapshotRequests.new(
        headers: headers_hash,
        base_url: @account.api_url,
        campaign_type: CAMPAIGN_TYPE_CODES[:sp]
      )
      @sd_snapshots = SnapshotRequests.new(
        headers: headers_hash,
        base_url: @account.api_url,
        campaign_type: CAMPAIGN_TYPE_CODES[:sd]
      )
      @sb_snapshots = SnapshotRequests.new(
        headers: headers_hash,
        base_url: @account.api_url,
        campaign_type: :hsa
      )
      @sp_reports = ReportRequests.new(
        headers: headers_hash,
        base_url: @account.api_url,
        campaign_type: CAMPAIGN_TYPE_CODES[:sp]
      )
      @sd_reports = ReportRequests.new(
        headers: headers_hash,
        base_url: @account.api_url,
        campaign_type: CAMPAIGN_TYPE_CODES[:sd]
      )
      @sb_reports = ReportRequests.new(
        headers: headers_hash,
        base_url: @account.api_url,
        campaign_type: :hsa
      )
      @v3_reports = ReportRequestsV3.new(
        headers: headers_hash,
        base_url: @account.api_url
      )
      @ad_groups = RequestCollection.new(
        headers: headers_hash,
        base_url: "#{@account.api_url}/v2/sp/adGroups"
      )
      @sd_ad_groups = RequestCollection.new(
        headers: headers_hash,
        base_url: "#{@account.api_url}/sd/adGroups"
      )
      @product_ads = RequestCollection.new(
        headers: headers_hash,
        base_url: "#{account.api_url}/v2/sp/productAds"
      )
      @sd_product_ads = RequestCollection.new(
        headers: headers_hash,
        base_url: "#{account.api_url}/sd/productAds"
      )
      @sp_negative_keywords = RequestCollectionWithCampaignType.new(
        headers: headers_hash,
        base_url: @account.api_url,
        resource: 'negativeKeywords',
        campaign_type: CAMPAIGN_TYPE_CODES[:sp]
      )
      @sb_negative_keywords = RequestCollectionWithCampaignType.new(
        headers: headers_hash,
        base_url: @account.api_url,
        resource: 'negativeKeywords',
        campaign_type: CAMPAIGN_TYPE_CODES[:sb]
      )
      @campaign_negative_keywords = RequestCollection.new(
        headers: headers_hash,
        base_url: "#{@account.api_url}/v2/sp/campaignNegativeKeywords"
      )
      @targets = RequestCollection.new(
        headers: headers_hash,
        base_url: "#{@account.api_url}/v2/sp/targets"
      )
      @portfolios = RequestCollection.new(
        headers: headers_hash,
        base_url: "#{@account.api_url}/v2/portfolios"
      )
      @suggested_keywords = SuggestedKeywordRequests.new(
        headers: headers_hash,
        base_url: "#{@account.api_url}/v2/sp"
      )
      @history = HistoryRequest.new(
        headers: headers_hash,
        base_url: @account.api_url
      )
      @invoices = InvoiceRequest.new(
        headers: headers_hash,
        base_url: "#{@account.api_url}/invoices"
      )
    end

    def campaigns(campaign_type)
      return @sp_campaigns if campaign_type == :sp
      return @sb_campaigns if campaign_type == :sb || campaign_type == :hsa
      return @sd_campaigns if campaign_type == :sd
    end

    def keywords(campaign_type)
      return @sp_keywords if campaign_type == :sp
      return @sb_keywords if campaign_type == :sb || campaign_type == :hsa
    end

    def negative_keywords(campaign_type)
      return @sp_negative_keywords if campaign_type == :sp
      return @sb_negative_keywords if campaign_type == :sb || campaign_type == :hsa
    end

    def snapshots(campaign_type)
      return @sp_snapshots if campaign_type == :sp
      return @sb_snapshots if campaign_type == :sb || campaign_type == :hsa
      return @sd_snapshots if campaign_type == :sd
    end

    def reports(campaign_type)
      return @sp_reports if campaign_type == :sp
      return @sb_reports if campaign_type == :sb || campaign_type == :hsa
      return @sd_reports if campaign_type == :sd
    end

    def reports_v3
      @v3_reports
    end

    def request(api_path: "",request_type: :get, payload: nil, url_params: nil, headers: headers_hash)
      @base_url = @account.api_url

      url = "#{@base_url}#{api_path}"

      request = Request.new(
        url: url,
        url_params: url_params,
        request_type: request_type,
        payload: payload,
        headers: headers
      )

      request.make_request
    end

    def profile_details
      @account.retrieve_profile(@profile_id)
    end

    def headers_hash(opts = {})
      headers_hash = {
        "Authorization" => "Bearer #{@account.retrieve_token()}",
        "Content-Type" => "application/json",
        "Amazon-Advertising-API-Scope" => @profile_id,
        "Amazon-Advertising-API-ClientId" => @account.client.client_id
      }

      headers_hash["Content-Encoding"] = "gzip" if opts[:gzip]

      return headers_hash
    end
  end
end
