# frozen_string_literal: true

module JpmGeo
  # Point represents a latitude, longitude location
  class Point
    PI = Math::PI
    PI_2 = 2 * PI
    DEG_TO_RAD = PI / 180.0
    RAD_TO_DEG = 180.0 / PI
    MIN_LAT = -PI / 2
    MAX_LAT = PI / 2
    MIN_LON = -PI
    MAX_LON = PI

    attr_accessor :lat, :lon
    attr_reader :radius, :radians

    class << self
      def from_lonlat(lonlat, radius: JpmGeo.radius)
        from_degrees(lon: lonlat.lon, lat: lonlat.lat, radius: radius)
      end

      def from_degrees(lon:, lat:, radius: JpmGeo.radius)
        new(lon: lon, lat: lat, radius: radius, radians: false)
      end

      def from_radians(lon:, lat:, radius: JpmGeo.radius, validate: true)
        new(lon: lon, lat: lat, radius: radius, radians: true, validate: validate)
      end

      def to_rad(degrees)
        degrees * DEG_TO_RAD
      end

      def to_deg(radians)
        radians * RAD_TO_DEG
      end
    end

    def to_radians
      return self if radians

      Point.from_radians(lon: Point.to_rad(lon), lat: Point.to_rad(lat), radius: radius)
    end

    def to_degrees
      return self unless radians

      Point.from_degrees(lon: Point.to_deg(lon), lat: Point.to_deg(lat), radius: radius)
    end

    def valid?
      point = to_radians
      point.lat >= MIN_LAT && point.lat <= MAX_LAT && point.lon >= MIN_LON && point.lon <= MAX_LON
    end

    def distance_to(point)
      raise ArgumentError, "JpmGeo::Point expected" unless point.is_a?(JpmGeo::Point)

      radians_distance_to(to_radians, point.to_radians)
    end

    # computes bounding coordinates all points that are within the great
    # circle of the given distance from this Point.
    # distance is in the same units as the radius argument.
    def bounding_coordinates(distance)
      raise ArgumentError, "invalid distance" if distance <= 0

      # angular distance in radians on a great circle
      raddist = distance / radius

      point = to_radians
      min = latlon(point.lat - raddist, 0)
      max = latlon(point.lat + raddist, 0)

      if min.lat > MIN_LAT && max.lat < MAX_LAT
        deltalon = Math.asin(Math.sin(raddist) / Math.cos(point.lat))
        min.lon = point.lon - deltalon
        max.lon = point.lon + deltalon
      else
        # a pole is within the distance
        min.lat = [min.lat, MIN_LAT].max
        max.lat = [max.lat, MAX_LAT].min
        min.lon = MIN_LON
        max.lon = MAX_LON
      end

      bounds = bounds_from_min_max(min, max)
      radians ? bounds : bounds.to_degrees
    end

    def to_s
      units = radians ? " rad" : "°"
      "JpmGeo::Point(#{lat}#{units}, #{lon}#{units})"
    end

    def ==(other)
      return false unless other.is_a?(JpmGeo::Point)

      point = radians ? other.to_radians : other.to_degrees
      point.lon == lon && point.lat == lat && point.radius == radius
    end

    private

    def radians_distance_to(point1, point2)
      Math.acos(Math.sin(point1.lat) * Math.sin(point2.lat) +
                Math.cos(point1.lat) * Math.cos(point2.lat) *
                Math.cos(point1.lon - point2.lon)) * radius
    end

    def bounds_from_min_max(min, max)
      # http://janmatuschek.de/LatitudeLongitudeBoundingCoordinates#PolesAnd180thMeridian
      # when the 180th meridian is with the query circle, return two sets of bounding coordinates.
      if min.lon < MIN_LON
        # (latmin, lonmin + 2PI), (latmax, PI) and (latmin, -PI), (latmax, lonmax)
        Bounds.from_points(latlon(min.lat, min.lon + PI_2), latlon(max.lat, PI),
                           latlon(min.lat, -PI), latlon(max.lat, max.lon))
      elsif max.lon > MAX_LON
        # (latmin, lonmin), (latmax, PI) and (latmin, -PI), (latmax, lonmax - 2PI).
        Bounds.from_points(latlon(min.lat, min.lon), latlon(max.lat, PI),
                           latlon(min.lat, -PI), latlon(max.lat, max.lon - PI_2))
      else
        # does not cross 180th meridian
        Bounds.from_points(min, max)
      end
    end

    def latlon(lat, lon)
      Point.from_radians(lat: lat, lon: lon, radius: radius, validate: false)
    end

    def initialize(lon:, lat:, radians: false, radius: JpmGeo.radius, validate: true)
      raise ArgumentError, "invalid radius" if radius <= 0

      @lon = lon
      @lat = lat
      @radius = radius
      @radians = radians
      raise ArgumentError, "invalid coordinates" if validate && !valid?
    end
  end
end
