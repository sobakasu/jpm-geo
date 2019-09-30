# frozen_string_literal: true

RSpec.describe JpmGeo::Point do
  let(:subject) { described_class }

  let(:lonlat_sydney) { lonlat(151.209900, -33.865143) }
  let(:lonlat_adelaide) { lonlat(138.599503, -34.921230) }
  let(:lonlat_alert) { lonlat(-62.410526, 82.508453) } # near north pole
  let(:lonlat_mcmurdo) { lonlat(166.6759949, -77.8460007) } # near south pole
  let(:lonlat_south_pole) { lonlat(0, -90) }
  let(:lonlat_north_pole) { lonlat(0, 90) }
  let(:lonlat_somosomo) { lonlat(179.957993, -16.773100) } # near 180th meridian

  let(:point_sydney) { subject.from_lonlat(lonlat_sydney) }
  let(:point_adelaide) { subject.from_lonlat(lonlat_adelaide) }
  let(:point_alert) { subject.from_lonlat(lonlat_alert) }
  let(:point_mcmurdo) { subject.from_lonlat(lonlat_mcmurdo) }
  let(:point_south_pole) { subject.from_lonlat(lonlat_south_pole) }
  let(:point_north_pole) { subject.from_lonlat(lonlat_north_pole) }
  let(:point_somosomo) { subject.from_lonlat(lonlat_somosomo) }

  before(:each) do
    JpmGeo.units = "km"
  end

  context "#initialize" do
    let(:lonlat_deg) { lonlat(-74.04455, 40.689604) }
    let(:lonlat_rad) { lonlat(-1.2923211906575673, 0.7101675611326549) }

    it "creates a new object from a lonlat" do
      point = subject.from_lonlat(lonlat_sydney)
      expect(point).to be
    end

    it "creates a new object from latitude and longitude in degrees" do
      point = subject.from_degrees(lon: lonlat_deg.lon, lat: lonlat_deg.lat)
      expect(point.lon).to eq(lonlat_deg.lon)
      expect(point.lat).to eq(lonlat_deg.lat)
    end

    it "creates a new object from latitude and longitude in radians" do
      point = subject.from_radians(lon: lonlat_rad.lon, lat: lonlat_rad.lat)
      expect(point.lon).to eq(lonlat_rad.lon)
      expect(point.lat).to eq(lonlat_rad.lat)
    end

    it "throws an error if latitude is out of bounds" do
      expect { subject.from_degrees(lon: lonlat_deg.lon, lat: 200) }.to raise_error(ArgumentError)
    end

    it "throws an error if longitude is out of bounds" do
      expect { subject.from_degrees(lon: 200, lat: lonlat_deg.lat) }.to raise_error(ArgumentError)
    end

    it "uses the units defined in JpmGeo" do
      JpmGeo.units = "m"
      point = subject.from_degrees(lon: 70, lat: 40)
      expect(point.radius).to eq(3963.19) # miles
    end

    it "uses the radius defined in JpmGeo" do
      JpmGeo.radius = 3963.19
      point = subject.from_degrees(lon: 70, lat: 40)
      expect(point.radius).to eq(3963.19) # miles
    end
  end

  context "#distance_to" do
    it "calculates distance between two points" do
      expect(point_sydney.distance_to(point_adelaide).to_i).to eq(1162)
    end

    it "calculates distance from the north pole" do
      expect(point_alert.distance_to(point_north_pole).to_i).to eq(833)
    end

    it "calculates distance from the south pole" do
      expect(point_mcmurdo.distance_to(point_south_pole).to_i).to eq(1351)
    end
  end

  context "#bounding_coordinates" do
    it "calculates the bounding box for a point" do
      bounds = point_adelaide.bounding_coordinates(800)
      expect(bounds.size).to eq(2)
    end

    # bounding coordinates are (latmin, -PI) and (PI/2, PI)
    it "calculates the bounding box for a point near the north pole" do
      distance = 1000
      expect(point_alert.distance_to(point_north_pole)).to be < distance

      bounds = point_alert.bounding_coordinates(distance)
      minlat = 1.2830831813688377
      expect(bounds.size).to eq(2)
      expect(bounds[0]).to eq(subject.from_radians(lat: minlat, lon: -Math::PI))
      expect(bounds[1]).to eq(subject.from_radians(lat: Math::PI / 2.0, lon: Math::PI))
    end

    # bounding coordinates are (-PI/2, -PI) and (latmax, PI).
    it "calculates the bounding box for a point near the south pole" do
      distance = 1500
      expect(point_mcmurdo.distance_to(point_south_pole)).to be < distance

      bounds = point_mcmurdo.bounding_coordinates(distance)
      maxlat = -1.1232275454125775
      expect(bounds.size).to eq(2)
      expect(bounds[0]).to eq(subject.from_radians(lat: -Math::PI / 2.0, lon: -Math::PI))
      expect(bounds[1]).to eq(subject.from_radians(lat: maxlat, lon: Math::PI))
    end

    # https://linestrings.com/bbox/#179.48835163412107,-17.222760097167342,180,-16.323439902832657
    # https://linestrings.com/bbox/#-180.0,-17.222760097167342,-179.57236563412113,-16.323439902832657
    it "returns two bounding boxes for a point near the 180th meridian" do
      bounds = point_somosomo.bounding_coordinates(50)
      expect(bounds.size).to eq(4) # two sets of bounding coordinates
      expect(bounds[0]).to eq(subject.from_lonlat(lonlat(179.48835163412107, -17.222760097167342)))
      expect(bounds[1]).to eq(subject.from_lonlat(lonlat(180, -16.323439902832657)))
      expect(bounds[2]).to eq(subject.from_lonlat(lonlat(-180.0, -17.222760097167342)))
      expect_lonlat(bounds[3], lonlat(-179.572, -16.323))
    end
  end

  private

  let(:delta) { 0.001 }

  def expect_lonlat(actual, expected)
    expect_lonlat_point(actual, subject.from_lonlat(expected))
  end

  def expect_lonlat_point(actual, expected_point)
    expect(actual.lat).to be_within(delta).of(expected_point.lat)
    expect(actual.lon).to be_within(delta).of(expected_point.lon)
  end

  def lonlat(lon, lat)
    lonlat = double(:lonlat)
    allow(lonlat).to receive(:lon).and_return(lon)
    allow(lonlat).to receive(:lat).and_return(lat)
    lonlat
  end

  def latlon(lat, lon)
    lonlat(lon, lat)
  end
end
