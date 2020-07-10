require 'blurb/request_collection'

class Blurb
  class HistoryRequest < RequestCollection
    def initialize(base_url:, headers:)
      @base_url = base_url
      @headers = headers
    end

    def retrieve(
      from_date: (DateTime.now - 90).strftime('%Q'),
      to_date: DateTime.now.strftime('%Q'),
      campaign_ids:,
      filters:,
      parent_campaign_id:,
      count: 100)

      payload = {
        sort: {
          key: 'DATE',
          direction: 'DESC'
        },
        fromDate: from_date.to_i, #Timestamp in milliseconds:
        toDate: to_date.to_i,
        eventTypes: {
          CAMPAIGN: {
            eventTypeIds: campaign_ids,
            filters: filters,
            parents: [{ campaignId: parent_campaign_id }]
          }
        },
        count: count
      }

      execute_request(
        api_path: "/history",
        request_type: :post,
        payload: payload
      )
    end
  end
end
