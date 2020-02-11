require 'blurb/request_collection'

class Blurb
  class RequestCollectionWithCampaignType < RequestCollection

    def initialize(campaign_type:, resource:, base_url:, headers:, bulk_api_limit: 100)
      @campaign_type = campaign_type
      @base_url = "#{base_url}/v2/#{@campaign_type}/#{resource}"
      @headers = headers
      @api_limit = bulk_api_limit
    end
  end
end 
