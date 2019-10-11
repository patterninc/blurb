require "blurb/account"
require "blurb/campaign_requests"
require "blurb/snapshot_requests"
require "blurb/report_requests"
require "blurb/request_collection"
require "blurb/request_collection_with_campaign_type"
require "blurb/suggested_keyword_requests"

class Blurb
  class Profile < BaseClass

    attr_accessor(
      :account,
      :ad_groups,
      :campaign_negative_keywords,
      :portfolios,
      :product_ads,
      :profile_id,
      :suggested_keywords,
      :targets
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
        campaign_type: CAMPAIGN_TYPE_CODES[:sb]
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
      @sb_snapshots = SnapshotRequests.new(
        headers: headers_hash,
        base_url: @account.api_url,
        campaign_type: CAMPAIGN_TYPE_CODES[:sb]
      )
      @sp_reports = ReportRequests.new(
        headers: headers_hash,
        base_url: @account.api_url,
        campaign_type: CAMPAIGN_TYPE_CODES[:sp]
      )
      @sb_reports = ReportRequests.new(
        headers: headers_hash,
        base_url: @account.api_url,
        campaign_type: CAMPAIGN_TYPE_CODES[:sb]
      )
      @ad_groups = RequestCollection.new(
        headers: headers_hash,
        base_url: "#{@account.api_url}/v2/sp/adGroups"
      )
      @product_ads = RequestCollection.new(
        headers: headers_hash,
        base_url: "#{account.api_url}/v2/sp/productAds"
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
    end

    def campaigns(campaign_type)
      return @sp_campaigns if campaign_type == :sp
      return @sb_campaigns if campaign_type == :sb || campaign_type == :hsa
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
    end

    def reports(campaign_type)
      return @sp_reports if campaign_type == :sp
      return @sb_reports if campaign_type == :sb || campaign_type == :hsa
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
