require "rails_helper"

RSpec.describe Consumption do
  let(:house) { House.create!(name: "Test house") }
  let(:flat) { Consumer.create!(house: house, name: "Flat 1", metering_location_id: "DE0000000000000000000000000000001", market_location_id: "5000000001") }
  let(:september) { Date.new(2026, 9, 1)..Date.new(2026, 9, 30) }

  before do
    start_date = Time.zone.parse("2026-09-01 12:00")
    Measurement.create!(location_id: flat.metering_location_id, start_date: start_date, end_date: start_date + 15.minutes, value_kwh: 10)
    Measurement.create!(location_id: flat.market_location_id, start_date: start_date, end_date: start_date + 15.minutes, value_kwh: 4)
  end

  it "calculates the solar consumption of a flat" do
    expect(flat.total_kwh(september)).to eq(10)
    expect(flat.grid_kwh(september)).to eq(4)
    expect(flat.solar_kwh(september)).to eq(6)
  end

  it "calculates the solar share of a flat" do
    expect(flat.solar_share(september)).to eq(60)
  end
end
