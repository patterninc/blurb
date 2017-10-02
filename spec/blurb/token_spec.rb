require "blurb"

RSpec.describe Blurb::Token do
  it "gets a token" do
    expect(Blurb::Token.retrieve()).not_to be nil
  end

end
