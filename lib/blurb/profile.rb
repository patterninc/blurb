require "blurb/account"
require "blurb/keyword"
require "blurb/campaign_requests"
require "blurb/snapshot_requests"
require "blurb/report_requests"

class Profile < BaseClass

  attr_accessor :profile_id, :account, :ad_groups

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
  end

  def campaigns(campaign_type)
    return @sp_campaigns if campaign_type == :sp
    return @sb_campaigns if campaign_type == :sb
  end

  def keywords(campaign_type)
    return @sp_keywords if campaign_type == :sp
    return @sb_keywords if campaign_type == :sb
  end

  def snapshots(campaign_type)
    return @sp_snapshots if campaign_type == :sp
    return @sb_snapshots if campaign_type == :sb
  end

  def reports(campaign_type)
    return @sp_reports if campaign_type == :sp
    return @sb_reports if campaign_type == :sb
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
