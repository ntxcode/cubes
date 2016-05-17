# Cubes

A wrapper for [Cubes OLAP Server](https://github.com/DataBrewery/cubes).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cubes'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cubes

## Configuration

You can configure the Cubes::Client pass configuration options to the constructor.

```ruby
client = Cubes::Client.new(base_url: 'http://your-cubes-server:5000')
```

By default, the client uses: `base_url: 'http://localhost:5000'`.

## Usage

*List all cubes*

```ruby
client.cubes
```

*Fetching the model specification of a cube*

```ruby
cube = client.cube('sales')
cube.model
```

*Aggregate the measures of a cube

```ruby
cube = client.cube('sales')
cube.aggregate(cut: 'date:2016')
cube.aggregate(cut: 'date:2016,5', drilldown: 'date')
```

*Generating reports*

```ruby
report = {
  summary: {
    query: :aggregate
  },
  by_year: {
    query: :aggregate
    drilldown: [:date],
    rollup: :date
  }
}

cube = client.cube('sales')
cube.report(report_data, cut: 'date:2016')
```
## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ntxcode/cubes.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

