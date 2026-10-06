# frozen_string_literal: true

require 'spec_helper'

# Pins the URL shapes recorded in docs/adr/0003.
RSpec.describe Blurb::RequestCollectionWithCampaignType do
  let(:base_url) { 'https://advertising-api.amazon.com' }
  let(:headers) { { 'Content-Type' => 'application/json' } }

  def collection(type, resource: 'campaigns', limit: 100)
    described_class.new(campaign_type: type, resource: resource, base_url: base_url, headers: headers,
                        bulk_api_limit: limit)
  end

  it 'maps Sponsored Brands to the legacy hsa code' do
    expect(Blurb::BaseClass::CAMPAIGN_TYPE_CODES).to eq(sp: 'sp', sb: 'hsa', sd: 'sd')
  end

  it 'puts sp and hsa resources under /v2' do
    sp = stub_request(:get, "#{base_url}/v2/sp/campaigns/1").to_return(body: '{}')
    hsa = stub_request(:get, "#{base_url}/v2/hsa/campaigns/1").to_return(body: '{}')

    collection('sp').retrieve(1)
    collection('hsa').retrieve(1)

    expect(sp).to have_been_requested
    expect(hsa).to have_been_requested
  end

  it 'puts sd resources at the root, without /v2' do
    stub = stub_request(:get, "#{base_url}/sd/campaigns/extended/1").to_return(body: '{}')

    collection('sd').retrieve_extended(1)

    expect(stub).to have_been_requested
  end

  it 'drops the sd segment for un-parameterised sd report GETs' do
    stub = stub_request(:get, "#{base_url}/reports").to_return(body: '[]')

    collection('sd', resource: 'reports').list

    expect(stub).to have_been_requested
  end

  it 'splits bulk creates into requests of at most bulk_api_limit items' do
    stub = stub_request(:post, "#{base_url}/v2/hsa/campaigns").to_return(body: fixture('create_response.json'))

    result = collection('hsa', limit: 2).create_bulk([{ name: 'a' }, { name: 'b' }, { name: 'c' }])

    expect(stub).to have_been_requested.twice
    expect(result.length).to eq(2)
  end

  it 'sends delete to the resource id' do
    stub = stub_request(:delete, "#{base_url}/v2/sp/campaigns/9").to_return(body: '{}')

    collection('sp').delete(9)

    expect(stub).to have_been_requested
  end
end
