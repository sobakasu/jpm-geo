# frozen_string_literal: true

module Jpm
  module Geo
    # Bounds is a bounding box defined by two Points.
    # If the bounding box crosses the 180th meridian, there will be two sets of bounding boxes
    # defined by four Points.
    class Bounds
      attr_reader :points, :radians

      def [](index)
        to_a[index]
      end

      def to_a
        points
      end

      def size
        points.size
      end

      def to_radians
        return self if radians

        Bounds.from_points(*points.collect(&:to_radians))
      end

      def to_degrees
        return self unless radians

        Bounds.from_points(*points.collect(&:to_degrees))
      end

      def to_s
        "Jpm::Geo::Bounds[#{points}]"
      end

      class << self
        def from_points(*points)
          new(*points)
        end
      end

      private

      def initialize(*points)
        @points = points
        @radians = points[0].radians
      end
    end
  end
end
