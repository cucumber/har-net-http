# Har::Net::Http

This library captures HTTP(S) traffic made by `net/http` as [HAR](http://www.softwareishard.com/blog/har-12-spec/).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'har-net-http'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install har-net-http

## Usage

To capture a HAR, load this library:

```ruby
require 'har/net/http'

# Reset the har, so that future requests will create a new HAR
Har::Net::HTTP.har = nil
```

Then, [make some HTTP requests](https://docs.ruby-lang.org/en/master/Net/HTTP.html).
If you prefer, you can also make HTTP requests with higher level libraries such as
[faraday](https://lostisland.github.io/faraday/), [http.rb](https://github.com/httprb/http),
[rest-client](https://github.com/rest-client/rest-client), [httparty](https://github.com/jnunemaker/httparty)
or any other library that is built on top of Ruby's `net/http` library.

When you're done, capture the HAR:

```ruby
har = JSON.stringify(Har::Net::HTTP.har)

# Do what you want with it!
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/cucumber/har-net-http.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
