# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Blurb do
  let(:token_url) { 'https://api.amazon.com/auth/o2/token' }
  let(:api_url) { 'https://advertising-api.amazon.com' }

  before do
    stub_request(:post, token_url).to_return(
      status: 200, body: fixture('token.json'), headers: { 'Content-Type' => 'application/json' }
    )
  end

  def blurb(**opts)
    described_class.new(client_id: 'cid', client_secret: 'secret', refresh_token: 'Atzr|fake', region: 'NA', **opts)
  end

  it 'exchanges the refresh token for an access token' do
    blurb(profile_id: '1111111111')

    expect(WebMock).to have_requested(:post, token_url)
      .with(body: hash_including('grant_type' => 'refresh_token', 'refresh_token' => 'Atzr|fake', 'client_id' => 'cid'))
  end

  it 'uses the given profile without listing profiles' do
    b = blurb(profile_id: '1111111111')

    expect(b.active_profile.profile_id).to eq('1111111111')
    expect(WebMock).not_to have_requested(:get, "#{api_url}/v2/profiles")
  end

  it 'lists profiles and activates the first when no profile_id is given' do
    stub_request(:get, "#{api_url}/v2/profiles").to_return(body: fixture('profiles.json'))

    b = blurb

    expect(b.profiles.map(&:profile_id)).to eq([1_111_111_111, 2_222_222_222])
    expect(b.active_profile.profile_id).to eq(1_111_111_111)
  end

  it 'maps each region to its API host' do
    expect(Blurb::Account::API_URLS).to include(
      'NA' => 'https://advertising-api.amazon.com',
      'EU' => 'https://advertising-api-eu.amazon.com',
      'FE' => 'https://advertising-api-fe.amazon.com'
    )
  end

  it 'sends the bearer token and client id on API calls' do
    stub = stub_request(:get, "#{api_url}/v2/profiles/1111111111")
           .with(headers: { 'Authorization' => 'Bearer Atza|fake-access-token',
                            'Amazon-Advertising-API-ClientId' => 'cid' })
           .to_return(body: '{"profileId": 1111111111}')

    blurb(profile_id: '1111111111').account.retrieve_profile('1111111111')

    expect(stub).to have_been_requested
  end
end
