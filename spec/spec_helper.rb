require "bundler/setup"
require "blurb"
require 'dotenv/load'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end

RSpec.shared_context "shared setup", :shared_context => :metadata do
  before do
    Blurb.profile_id = ENV["PROFILE_ID"]
    Blurb.client_id = ENV["CLIENT_ID"]
    Blurb.client_secret = ENV["CLIENT_SECRET"]
    Blurb.refresh_token = ENV["REFRESH_TOKEN"]
    Blurb.region = "TEST"
    @bid_recommendation_instance = Blurb::BidRecommendation.new()
    @campaign_instance = Blurb::Campaign.new()
    @profile_instance = Blurb::Profile.new()
    @report_instance = Blurb::Report.new()
    @snapshot_instance = Blurb::Snapshot.new()
    @suggested_keyword_instance = Blurb::SuggestedKeyword.new()
    @keyword_instance = Blurb::Keyword.new()
    @ad_group_instance = Blurb::AdGroup.new()
  end
end

RSpec.configure do |rspec|
  rspec.include_context "shared setup", :include_shared => true
end
