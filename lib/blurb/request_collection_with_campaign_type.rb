require 'blurb/request_collection'

class RequestCollectionWithCampaignType < RequestCollection

  def initialize(campaign_type:, resource:, base_url:, headers:)
    @campaign_type = campaign_type
    @base_url = "#{base_url}/v2/#{@campaign_type}/#{resource}"
    @headers = headers
  end
end
