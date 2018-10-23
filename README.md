# Blurb

[![CircleCI](https://circleci.com/gh/iserve-products/blurb.svg?style=shield)](https://circleci.com/gh/iserve-products/blurb)
[![TravisCI](https://travis-ci.org/iserve-products/blurb.svg?branch=master)](https://travis-ci.org/iserve-products/blurb)
[![Gem Version](https://badge.fury.io/rb/blurb.svg)](https://badge.fury.io/rb/blurb)

Blurb is an API wrapper (written in Ruby and packaged as a Gem) for the Amazon Advertising API. The Amazon Ad API lets you tie in programmatically to
Amazon's Advertising Service. More info can be found at [Amazon Advertising](https://services.amazon.com/advertising/overview.htm?ld=NSGoogleAS)

Version 0.2.0 has been updated to use v2.0 of the Amazon Advertising API.  

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'blurb'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install blurb

## API Credentials

Getting setup to make calls to the Amazon Advertising API can unfortunately be a tedious process.
You will need to apply for and have a valid Amazon Advertising Account. You can find that info
here: [Amazon Advertising](https://advertising.amazon.com/)

You may also want to get a copy of the advertising docs and getting started guides which can be found here:

1. [Amazon Advertising API Getting Started Guide](https://advertising.amazon.com/API/docs/v2/guides/get_started?ref_=a20m_us_api_dc1)
2. [Amazon Advertising API Reference](https://advertising.amazon.com/API/docs/v2/reference/profiles?ref_=a20m_us_api_dc2)

Once you have an account you will be assigned a "client_id" and a "client_secret".

Next you will need to obtain an authorization code from the Amazon API. You can do that by making a browser request to the following URL:

```
https://www.amazon.com/ap/oa?client_id=YOUR_LWA_CLIENT_ID &scope=cpc_advertising:campaign_management&response_type=code&redirect_uri=YOUR_RETURN_URL
```

Enter your client ID in the URL and a valid website as the return URL. Amazon will direct you to login.  Login with your
advertising credentials.  You will then be redirected back to your provided URL.  NOTICE that you will have an authorization code listed
on the return URL.  YOU NEED THIS code to now obtain your refresh token.

## Obtaining Your Refresh Token
Once you have your authorization code, you can obtain your first access token and refresh token.
Do that by making a curl call to the following:

```
curl \
  -X POST \
  -H "Content-Type:application/x-www-form-urlencoded;charset=UTF-8" \
  --data "grant_type=authorization_code&code=AUTH_CODE&redirect_uri=YOUR_RETURN_URL&client_id=YOUR_CLIENT_ID&client_secret=YOUR_SECRET_KEY" \
  https://api.amazon.com/auth/o2/token
```

The response should return a JSON payload. Find the "refresh token" and save it's value.  
You will need this token to make repeated API calls.  The refresh token is tied to your account
and won't change as long as your account is valid and hasn't changed.

The Blurb API wrapper will then use the refresh token to make OAUTH calls to get a valid
access token and call the API with the appropriate bearer token headers setup.

## Obtaining Your Profile ID
The last piece you need to obtain before you can be on your way to using the API is the profile.
The profile scopes you to certain features and you can have multiple profiles setup for your account.

You can find your profiles by making the following Blurb call.

```ruby
  Blurb.client_id = "<YOUR_CLIENT_ID>"
  Blurb.client_secret = "<YOUR_CLIENT_SECRET>"
  Blurb.refresh_token = "<YOUR_REFRESH_TOKEN>"

  Blurb::Profile.list()
```

This will return a JSON payload of profile information for your account.  You can then select the profile ID you want to use.

## Blurb Values Setup
Before using the Blurb API wrapper you need to set your API values. Simply do that by initializing the Blurb values to your API values.
If you are using Rails, see below.

```ruby
Blurb.profile_id = "<YOUR_PROFILE_ID>"
Blurb.client_id = "<YOUR_CLIENT_ID>"
Blurb.client_secret = "<YOUR_CLIENT_SECRET>"
Blurb.refresh_token = "<YOUR_REFRESH_TOKEN>"
```

## Rails Integration

You can setup the Amazon API keys and tokens in an initializer script.
Create a file called config/initializers/blurb.rb and setup the following values

```ruby
Blurb.profile_id = "<YOUR_PROFILE_ID>"
Blurb.client_id = "<YOUR_CLIENT_ID>"
Blurb.client_secret = "<YOUR_CLIENT_SECRET>"
Blurb.refresh_token = "<YOUR_REFRESH_TOKEN>"
```

If you don't want to store your API values in your code which gets checked into a public repo, you can utilize ENV variables

```ruby
Blurb.profile_id = ENV["YOUR_PROFILE_ID_VAR"]
Blurb.client_id = ENV["YOUR_CLIENT_ID_VAR"]
Blurb.client_secret = ENV["YOUR_CLIENT_SECRET_VAR"]
Blurb.refresh_token = ENV["YOUR_REFRESH_TOKEN_VAR"]
```

You could also store API values in a persistence store and initialize from there too.

## API Environments

By default Blurb will run API calls to the Amazon Advertising API production environment.
If you are under development and want to test out the API to see what it can do, you can set
the following Blurb property to use the API test environment.

```ruby
Blurb.test_env = true
```

## Usage

All API calls have been setup as closely as possible to REST Resource calls.
All you need to do is find the appropriate resource object and make a method call on it and Blurb will do the rest.

In calls that require 'campaign_type' as a parameter, you must pass in either 'sp' for sponsored products or 'hsa' for sponsored brands (formerly known as headline search ads).  

NOTE: Not all API endpoints are currently supported by Blurb.  Over time we will get more
endpoints added. In the mean time you are always welcome to submit a pull request.

### Profiles
List account profiles

```ruby
Blurb::Profile.list()
```

### Campaigns
List campaigns

```ruby
Blurb::Campaign.list(campaign_type)
```

Get a campaign

```ruby
Blurb::Campaign.retrieve(campaign_id, campaign_type)
```

Create a campaign

```ruby
Blurb::Campaign.create(campaign_type, {
  "name" => "test",
  "state" => "enabled",
  "dailyBudget" => 10,
  "startDate" => (Time.now).strftime('%Y%m%d'),
  "targetingType" => "abc"
})
```

Note: Sponsored Brands cannot be created through the Amazon Advertising API and must be added through the user interface.  The create call only works for Sponsored Products.

### Reports
Request a report

```ruby
payload_response = Blurb::Report.create({
  "campaignType" => Blurb::Report::SPONSORED_PRODUCTS,
  "recordType" => Blurb::Report::KEYWORDS,
  "reportDate" => (Time.now - 2592000).strftime('%Y%m%d'),
  "metrics" => "impressions,clicks"
})
```
If no metrics are included in the request, blurb will request all available metrics available for the given campaign type and report type.

Report record types are

```ruby
Blurb::Report::KEYWORDS
Blurb::Report::CAMPAIGNS
Blurb::Report::AD_GROUPS
Blurb::Report::PRODUCT_ADS
```

Campaign types are

```ruby
Blurb::Report::SPONSORED_PRODUCTS
Blurb::Report::SPONSORED_BRANDS
```

Check report status

```ruby
Blurb::Report.status(report_id)
```

Download report file content

```ruby
Blurb::Report.download(report_location_url)
```

### Snapshots
Request a snapshot

```ruby
payload_response = Blurb::Snapshot.create({
  "recordType" => Blurb::Snapshot::KEYWORDS,
  "stateFilter" => "enabled,paused,archived"
})
```

Report record types are

```ruby
Blurb::Snapshot::KEYWORDS
Blurb::Snapshot::CAMPAIGNS
Blurb::Snapshot::AD_GROUPS
Blurb::Snapshot::PRODUCT_ADS
Blurb::Snapshot::NEGATIVE_KEYWORDS
Blurb::Snapshot::CAMPAIGN_NEGATIVE_KEYWORDS
```

Check snapshot status

```ruby
Blurb::Snapshot.status(snapshot_id)
```

Download snapshot file content

```ruby
Blurb::Snapshot.download(snapshot_location_url)
```

### Suggested Keywords
Suggestions by ASIN

```ruby
Blurb::SuggestedKeyword.asin_suggestions({
  "asinValue" => "B0006HUJJO"
})
```

Suggestions for a list of ASIN's

```ruby
Blurb::SuggestedKeyword.bulk_asin_suggestions({
  "asins" => ["B0006HUJJO","B0042SWOHI"]
})
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/iserve-products/blurb. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
