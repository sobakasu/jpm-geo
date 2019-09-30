# frozen_string_literal: true

RSpec.describe Jpm::Geo do
  after(:all) do
    Jpm::Geo.units = "km"
  end

  it "has a version number" do
    expect(Jpm::Geo::VERSION).not_to be nil
  end

  context "#units" do
    it "allows changing units to miles" do
      Jpm::Geo.units = "m"
      expect(Jpm::Geo.radius).to eq(3963.19)
    end

    it "allows changing units to kilometers" do
      Jpm::Geo.units = "km"
      expect(Jpm::Geo.radius).to eq(6371.01)
    end
  end
end
