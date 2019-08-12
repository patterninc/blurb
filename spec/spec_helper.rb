require "bundler/setup"
require "blurb"
require 'dotenv/load'
require 'byebug'
require 'faker'

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

  # Sleep half a second between tests to avoid amazon advertising api throttling
  config.before(:each) { sleep(1) }
end
