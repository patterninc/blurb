require 'spec_helper'

RSpec.describe 'Portfolio Requests' do
  before(:all) do
    blurb = Blurb.new()
    @resource = blurb.active_profile.portfolios
    @resource_name = 'portfolio'
    @create_hash = {
      name: Faker::Lorem.word,
      state: 'enabled',
      budget: {
        amount: rand(0..1000).to_f,
        policy: 'dateRange',
        startDate: '20191231',
      },
    }
    @update_hash = {
      name: Faker::Lorem.word,
      state: 'enabled',
      budget: {
        amount: rand(0..1000).to_f,
      },
    }
    @ignored_examples = [:delete]
  end

  include_examples 'request collection'
end
