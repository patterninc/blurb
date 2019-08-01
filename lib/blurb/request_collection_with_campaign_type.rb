require 'blurb/request_collection'

class RequestCollectionWithCampaignType < RequestCollection

  def initialize(campaign_type:, **request_collection_params)
    super(request_collection_params)
    @campaign_type = campaign_type
  end
end
