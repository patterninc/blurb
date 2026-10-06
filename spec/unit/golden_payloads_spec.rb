# frozen_string_literal: true

require 'spec_helper'

# Golden-file tests: the exact JSON body each builder sends to Amazon is stored in
# spec/fixtures/golden/<name>.json. A diff means the wire payload changed. If the
# change is intended, regenerate with `UPDATE_GOLDEN=1 make test` and review the diff.
RSpec.describe 'request payload golden files' do
  let(:base_url) { 'https://advertising-api.amazon.com' }
  let(:headers) { { 'Content-Type' => 'application/json' } }
  let(:golden_dir) { File.join(Fixtures::DIR, 'golden') }

  def capture_body(method, url)
    body = nil
    stub_request(method, url).to_return do |req|
      body = req.body
      { status: 200, body: '{}' }
    end
    yield
    JSON.pretty_generate(JSON.parse(body))
  end

  def expect_golden(name, actual)
    path = File.join(golden_dir, "#{name}.json")
    File.write(path, "#{actual}\n") if ENV['UPDATE_GOLDEN'] == '1'
    expect(actual).to eq(File.read(path).chomp), "#{path} differs; UPDATE_GOLDEN=1 regenerates it"
  end

  def reports(type)
    Blurb::ReportRequests.new(campaign_type: type, base_url: base_url, headers: headers)
  end

  {
    'report_sp_keywords' => ['sp', :keywords, nil],
    'report_sp_keywords_query_segment' => ['sp', :keywords, 'query'],
    'report_hsa_campaigns' => ['hsa', :campaigns, nil],
    'report_sd_campaigns' => ['sd', :campaigns, nil]
  }.each do |name, (type, record_type, segment)|
    it "matches #{name}" do
      url = "#{base_url}/v2/#{type}/#{record_type}/report"
      body = capture_body(:post, url) do
        reports(type).create(record_type: record_type, report_date: Date.new(2024, 1, 31), segment: segment)
      end

      expect_golden(name, body)
    end
  end

  it 'matches history_retrieve' do
    history = Blurb::HistoryRequest.new(base_url: base_url, headers: headers)
    body = capture_body(:post, "#{base_url}/history") do
      history.retrieve(from_date: 1_704_067_200_000, to_date: 1_706_659_200_000, campaign_ids: [1, 2],
                       filters: ['BUDGET_AMOUNT'], parent_campaign_id: 3, count: 10)
    end

    expect_golden('history_retrieve', body)
  end
end
