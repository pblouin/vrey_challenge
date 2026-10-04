require "rails_helper"

RSpec.describe Consumption do
  let(:house) { House.create!(name: "Test house") }
  let(:flat) { Consumer.create!(house: house, name: "Flat 1", metering_location_id: "total-1", market_location_id: "grid-1") }
  let(:september) { Date.new(2026, 9, 1)..Date.new(2026, 9, 30) }

  def add_measurement(location_id, time, value_kwh)
    start_date = Time.zone.parse(time)
    Measurement.create!(location_id: location_id, start_date: start_date, end_date: start_date + 15.minutes, value_kwh: value_kwh)
  end

  before do
    add_measurement("total-1", "2026-09-01 12:00", 10)
    add_measurement("grid-1", "2026-09-01 12:00", 4)
    add_measurement("total-1", "2026-09-02 12:00", 10)
    add_measurement("grid-1", "2026-09-02 12:00", 4)
  end

  it "calculates the total, grid and solar consumption of a flat" do
    expect(flat.total_kwh(september)).to eq(20)
    expect(flat.grid_kwh(september)).to eq(8)
    expect(flat.solar_kwh(september)).to eq(12)
  end

  it "calculates the solar share of a flat" do
    expect(flat.solar_share(september)).to eq(60)
  end

  it "counts the days with data" do
    expect(flat.days_with_data(september)).to eq(2)
  end

  it "adds up the flats for the house" do
    flat
    Consumer.create!(house: house, name: "Flat 2", metering_location_id: "total-2", market_location_id: "grid-2")
    add_measurement("total-2", "2026-09-01 12:00", 5)
    add_measurement("grid-2", "2026-09-01 12:00", 5)

    expect(house.total_kwh(september)).to eq(25)
    expect(house.grid_kwh(september)).to eq(13)
    expect(house.solar_kwh(september)).to eq(12)
  end

  it "returns a solar share of 0 when there is no data" do
    october = Date.new(2026, 10, 1)..Date.new(2026, 10, 31)

    expect(flat.solar_share(october)).to eq(0)
  end
end
