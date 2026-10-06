# frozen_string_literal: true

require 'spec_helper'

# Pins the behaviour recorded in docs/adr/0002.
RSpec.describe Blurb::Request do
  let(:url) { 'https://advertising-api.amazon.com/v2/sp/campaigns' }
  let(:headers) { { 'Authorization' => 'Bearer token', 'Content-Type' => 'application/json' } }

  def request(**opts)
    described_class.new(url: url, headers: headers, request_type: :get, **opts)
  end

  describe '#make_request' do
    it 'snake_cases response keys into symbols' do
      stub_request(:get, url).to_return(status: 200, body: fixture('sp_campaigns.json'))

      result = request.make_request

      expect(result.first).to include(campaign_id: 123_456_789, daily_budget: 10.0, premium_bid_adjustment: false)
      expect(result.first.keys).to all(be_a(Symbol))
    end

    it 'camelCases query params, formats dates and keeps upper-case keys' do
      stub = stub_request(:get, "#{url}?campaignIdFilter=1,2&startDate=20240131&SKU=abc")
             .to_return(status: 200, body: '[]')

      request(url_params: { campaign_id_filter: '1,2', start_date: Date.new(2024, 1, 31), SKU: 'abc' }).make_request

      expect(stub).to have_been_requested
    end

    it 'camelCases nested POST payload keys' do
      stub = stub_request(:post, url)
             .with(body: [{ 'name' => 'x', 'dailyBudget' => 5, 'bidding' => { 'adjustmentStrategy' => 'up' } }].to_json)
             .to_return(status: 207, body: fixture('create_response.json'))

      result = described_class.new(
        url: url, headers: headers, request_type: :post,
        payload: [{ name: 'x', daily_budget: 5, bidding: { adjustment_strategy: 'up' } }]
      ).make_request

      expect(stub).to have_been_requested
      expect(result).to eq([{ code: 'SUCCESS', campaign_id: 123_456_789 }])
    end

    it 'raises RequestThrottled on 429' do
      stub_request(:get, url).to_return(status: 429, body: fixture('error_throttled.json'))

      expect { request.make_request }.to raise_error(Blurb::RequestThrottled)
    end

    it 'raises InvalidReportRequest on 406 for a report URL' do
      report_url = 'https://advertising-api.amazon.com/v2/reports/abc'
      stub_request(:get, report_url).to_return(status: 406, body: fixture('error_invalid_report.json'))

      expect { described_class.new(url: report_url, headers: headers, request_type: :get).make_request }
        .to raise_error(Blurb::InvalidReportRequest)
    end

    it 're-raises RestClient::NotAcceptable on 406 for a non-report URL' do
      stub_request(:get, url).to_return(status: 406, body: '{}')

      expect { request.make_request }.to raise_error(RestClient::NotAcceptable)
    end

    it 'raises FailedRequest with the body on other error responses' do
      stub_request(:get, url).to_return(status: 400, body: fixture('error_bad_request.json'))

      expect { request.make_request }.to raise_error(Blurb::FailedRequest, /INVALID_ARGUMENT/)
    end

    it 'follows a 307 and returns the downloaded body unparsed (report downloads)' do
      download = 'https://offline-report-storage.example.com/report.json.gz'
      stub_request(:get, url).to_return(status: 307, headers: { 'Location' => download })
      stub_request(:get, download).to_return(status: 200, body: 'raw-gzip-bytes')

      expect(request.make_request.body).to eq('raw-gzip-bytes')
    end
  end
end
