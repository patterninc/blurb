require "bundler/setup"
require "blurb"

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
    Blurb.test_env = true
    Blurb.profile_id = ENV["PROFILE_ID"]
    Blurb.client_id = ENV["CLIENT_ID"]
    Blurb.client_secret = ENV["CLIENT_SECRET"]
    Blurb.refresh_token = ENV["REFRESH_TOKEN"]
  end
end

RSpec.configure do |rspec|
  rspec.include_context "shared setup", :include_shared => true
end
