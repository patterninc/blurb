# Blurb

Blurb is an API wrapper (written in Ruby and packaged as a Gem) for the Amazon Advertising API. The Amazon Ad API lets you tie in programmatically to
Amazon's Advertising Service. More info can be found at https://services.amazon.com/advertising/overview.htm?ld=NSGoogleAS

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'blurb'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install blurb

## Usage

Getting setup to make calls to the Amazon Advertising API can unfortunately be a tedious process.

## Rails Integration

You can setup the Amazon API keys and tokens in an initializer script.
Create a file called config/initializers/blurb.rb and setup the following values

```ruby
Blurb.profile_id = "<YOUR_PROFILE_ID>"
Blurb.client_id = "<YOUR_CLIENT_ID>"
Blurb.client_secret = "<YOUR_CLIENT_SECRET>"
Blurb.refresh_token = "<YOUR_REFRESH_TOKEN>"
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/blurb. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
