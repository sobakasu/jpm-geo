# frozen_string_literal: true

# Finds points within a distance of a latitude/longitude point using bounding coordinates.
# http://janmatuschek.de/LatitudeLongitudeBoundingCoordinates
module JpmGeo
  class Error < StandardError; end

  EARTH_RADIUS_KM = 6371.01
  EARTH_RADIUS_M = 3963.19

  class << self
    attr_writer :radius

    def radius
      @radius || EARTH_RADIUS_KM
    end

    def units=(units)
      raise ArgumentError, "invalid units" unless units && %w[km m].include?(units.to_s)

      @units = units
      @radius = units == "km" ? EARTH_RADIUS_KM : EARTH_RADIUS_M
    end
  end
end

require "jpm_geo/version"
require "jpm_geo/point"
require "jpm_geo/bounds"
