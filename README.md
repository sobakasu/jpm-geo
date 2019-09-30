# JpmGeo

Computes the bounding coordinates of all points on the surface of a sphere that have a great circle distance to the given point. This code was ported to ruby directly from http://janmatuschek.de/LatitudeLongitudeBoundingCoordinates, and is owned by Jan Philip Matuschek.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'jpm-geo'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install jpm-geo

## Usage

```
# lonlat is an object that responds to 'lon' and 'lat' methods
point = JpmGeo::Point.from_lonlat(lonlat) 
bounds = point.bounds(100) # km
p [bounds.min.lat, bounds.min.lon, bounds.max.lat, bounds.max.lon]
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/sobakasu/jpm-geo. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the JpmGeo project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/sobakasu/jpm-geo/blob/master/CODE_OF_CONDUCT.md).
