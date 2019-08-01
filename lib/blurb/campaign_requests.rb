require 'blurb/request_collection_with_campaign_type'

class CampaignRequests < RequestCollectionWithCampaignType
  def initialize(**initialize_params)
    super(initialize_params)
    @base_url = "#{@base_url}/v2/#{@campaign_type}/campaigns"
  end

  def create_bulk(create_array)
    create_array = map_campaign_payload(create_array)
    super(create_array)
  end

  def update_bulk(update_array)
    update_array = map_campaign_payload(update_array)
    super(update_array)
  end

  private

    def map_campaign_payload(payload)
      campaign_type_string = "sponsoredProducts" if @campaign_type == CAMPAIGN_TYPE_CODES[:sp]
      campaign_type_string = "sponsoredBrands" if @campaign_type == CAMPAIGN_TYPE_CODES[:sb]
      payload.each{ |p| p[:campaign_type] = campaign_type_string }
    end
end
