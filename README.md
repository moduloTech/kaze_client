# KazeClient

This is the official Ruby client library for Kaze API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'kaze_client'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install kaze_client

## Usage

Here is an example of how to chain requests:

```ruby
require 'kaze_client'

client = KazeClient::Client.new('https://app.kaze.so', token: 'A_valid_token')
request = KazeClient::JobsRequest.new.filter_by_status('completed').filter_by_query('client_reference_42')

response = client.execute(request)

first_job = response.dig['data'].first
puts("First job id: #{first_job['id']}")

request = KazeClient::JobRequest.new(first_job['id'])

job = client.execute(request)
pickup_address = job.fetch_data_from_child('pick_up_address', field: 'city')
puts("City: #{pickup_address}")
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/moduloTech/kaze_client. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/moduloTech/kaze_client/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the KazeClient project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/moduloTech/kaze_client/blob/master/CODE_OF_CONDUCT.md).
