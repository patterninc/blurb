require 'request_collection_with_campaign_type'

class SnapshotRequests < RequestCollectionWithCampaignType
  def initialize(campaign_type:, base_url:, headers:)
    @campaign_type = campaign_type
    @base_url = "#{base_url}/v2/#{@campaign_type}"
    @headers = headers
  end

  def create(record_type, state_filter='enabled,paused')
    execute_request(
      api_path: "/#{record_type.to_s.camelize(:lower)}/snapshot",
      request_type: :post,
      payload: {state_filter: state_filter}
    )
  end

  def retrieve(snapshot_id)
    execute_request(
      api_path: "/snapshots/#{snapshot_id}",
      request_type: :get,
    )
  end
end
