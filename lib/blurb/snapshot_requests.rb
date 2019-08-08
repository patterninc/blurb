require 'blurb/request_collection_with_campaign_type'

class Blurb
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

    def download(snapshot_id)
      download_url = retrieve(snapshot_id)[:location]
      headers = @headers.dup["Content-Encoding"] = "gzip"
      Request.new(
        url: download_url,
        request_type: :get,
        headers: @headers
      ).make_request
    end
  end
end
