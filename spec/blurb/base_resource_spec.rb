require "spec_helper"

RSpec.describe Blurb::BaseResource do
  include_context "shared setup"

  it "gets a token" do
    expect(@campaign_instance.retrieve_token()).not_to be nil
  end

end
