require "spec_helper"

RSpec.describe Blurb::HistoryRequest do
  before(:all) do
    @blurb = Blurb.new()
  end

  RSpec.shared_examples "history" do
    it "retrieves campaigns history" do
      @from_date = (DateTime.now - 20).strftime('%Q')
      @to_date = DateTime.now.strftime('%Q')
      @campaign_ids = ['147884122743903', '39034535622986']
      @filters = ['BUDGET_AMOUNT']
      @parent_campaign_id = '162846824163775'
      @count = 60

      @retrieve_response = resource.retrieve(
        from_date: @from_date,
        to_date: @to_date,
        campaign_ids: @campaign_ids,
        filters: @filters,
        parent_campaign_id: @parent_campaign_id,
        count: @count)
      expect(@retrieve_response.has_key?(:events)).to be_truthy
      expect(@retrieve_response[:page_size]).to eq(@count)
    end
  end

  context "campaign history" do
    let(:resource) { @blurb.active_profile.history }

    include_examples "history"
  end
end
