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

### Configuration

```
# use miles as a distance unit (default is kilometers)
JpmGeo.units = 'm'

# specify default radius (default is Earth kilometers)
JpmGeo.radius = 3389.5 # Mars radius (km)
```

### Creating points
```
# lonlat is an object that responds to 'lon' and 'lat' methods
point = JpmGeo::Point.from_lonlat(lonlat) 

# from degrees
point = JpmGeo::Point.from_degrees(lat: 51.50853, lon: -0.12574) # London

# from radians
point = JpmGeo::Point.from_radians(lat: 0.8990, lon: -0.0022) # London (ish)

# converting to/from radians/degrees
point = point.to_radians
point = point.to_degrees
```

### Finding distance between points

```
# distance is in the same units as radius
distance = point.distance_to(point2)
```

### Finding bounding coordinates

```
bounds = point.bounds(100) # km
p [bounds[0].lat, bounds[0].lon, bounds[1].lat, bounds[1].lon]
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/sobakasu/jpm-geo. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the JpmGeo project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/sobakasu/jpm-geo/blob/master/CODE_OF_CONDUCT.md).
