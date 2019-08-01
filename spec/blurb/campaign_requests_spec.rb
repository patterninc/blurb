require "spec_helper"

RSpec.describe CampaignRequests do
  before(:all) do
    @account = Account.new(
      refresh_token: ENV["REFRESH_TOKEN"],
      region: "TEST",
      client_id: ENV["CLIENT_ID"],
      client_secret: ENV["CLIENT_SECRET"]
    )
    @profile = @account.active_profile
  end

  context "sponsored products" do
    let(:campaigns) { @profile.campaigns(:sp) }

    describe '#list' do
      it "gets a list of campaigns" do
        @response = campaigns.list()
        expect(@response.length).to be > 0
      end
      it "test url params"
    end

    describe '#list_extended' do
      it "gets a list of campaigns" do
        @response = campaigns.list_extended()
        expect(@response.length).to be > 0
      end
      it "test url params"
    end

    describe '#retrieve' do
      it "correctly retrieves a campaign" do
        campaign_id = campaigns.list().first[:campaign_id]
        @response = campaigns.retrieve(campaign_id)
        expect(@response[:campaign_id]).to eql(campaign_id)
      end
    end

    describe '#retrieve_extended' do
      it "correctly retrieves extended campaign" do
        campaign_id = campaigns.list().first[:campaign_id]
        @response = campaigns.retrieve_extended(campaign_id)
        expect(@response[:campaign_id]).to eql(campaign_id)
      end
    end

    describe '#create' do
      it "creates a campaign" do
        @response = campaigns.create(
          name: Faker::Lorem.word,
          state: ["enabled", "paused", "archived"].sample,
          targeting_type: ["manual", "auto"].sample,
          daily_budget: rand(10000),
          start_date: Date.today
        )
        expect(@response.length).to eql(1)
        expect(@response.first[:code]).to eql("SUCCESS")
      end
    end

    describe '#create_bulk' do
      it 'succesfully creates over 100 campaigns'
    end

    describe '#update' do
      it "updates a campaign" do
        campaign = campaigns.list().select{ |c| c[:state] == 'enabled' }.sample
        @response = campaigns.update(
          campaign_id: campaign[:campaign_id],
          end_date: Date.today + rand(1000)
        )
        expect(@response.length).to eql(1)
        expect(@response.first[:code]).to eql("SUCCESS")
      end
    end

    describe '#update_bulk' do
      it 'succesfully updates over 100 campaigns'
    end

    describe '#delete' do
      it "deletes a campaign" do
        campaign = campaigns.list().select{ |c| c[:state] == 'enabled' }.sample
        @response = campaigns.delete(campaign[:campaign_id])
        expect(@response[:code]).to eql("SUCCESS")
      end
    end
  end

  after(:each) do |example|
    puts @response if example.exception
  end
end
