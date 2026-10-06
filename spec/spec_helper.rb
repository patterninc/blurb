# Two suites share this helper:
#   - default (`make test`, CI): hermetic specs; HTTP is blocked by WebMock and every
#     example tagged :live (everything under spec/blurb/) is excluded.
#   - BLURB_LIVE=1 (`make test-live`): only the :live specs, against the real Amazon
#     Advertising API, with credentials from .env.
LIVE = ENV["BLURB_LIVE"] == "1"

unless LIVE
  require "simplecov"
  SimpleCov.start do
    add_filter "/spec/"
    # Current hermetic coverage, rounded down. Raise it as unit specs are added.
    minimum_coverage 77
  end
end

require "bundler/setup"
# Load what a Rails consumer already has loaded. Outside Rails the gem currently fails:
#   - ActiveSupport >= 7.1 must be loaded before its core_ext files, and
#     lib/blurb/request.rb requires only active_support/core_ext/string;
#   - Request#make_request calls `present?` on a RestClient::Response, which needs
#     active_support/core_ext/object/blank.
# Follow-up: add both requires to lib/blurb/request.rb, then delete these two lines.
require "active_support"
require "active_support/core_ext/object/blank"
require "blurb"
require 'dotenv/load'
require 'byebug'
require 'faker'
require "webmock/rspec"

Dir.glob("#{File.dirname __FILE__}/support/*.rb").each { |f| require f }

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  # Include support files
  config.include RequestCollectionExamples

  # Everything under spec/blurb/ calls the live API.
  config.define_derived_metadata(file_path: %r{/spec/blurb/}) do |metadata|
    metadata[:live] = true
  end

  if LIVE
    config.filter_run_including :live
    WebMock.allow_net_connect!
    # Sleep between live examples to avoid Amazon Advertising API throttling
    config.before(:each) { sleep(1) }
  else
    config.filter_run_excluding :live
  end
end
