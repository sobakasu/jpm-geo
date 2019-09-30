# frozen_string_literal: true

RSpec.describe JpmGeo do

  after(:all) do
    JpmGeo.units = 'km'
  end

  it "has a version number" do
    expect(JpmGeo::VERSION).not_to be nil
  end

  context "#units" do
    it "allows changing units to miles" do
      JpmGeo.units = 'm'
      expect(JpmGeo.radius).to eq(3963.19)
    end

    it "allows changing units to kilometers" do
      JpmGeo.units = 'km'
      expect(JpmGeo.radius).to eq(6371.01)
    end
  end
end
