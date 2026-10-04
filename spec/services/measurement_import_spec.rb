require "rails_helper"

RSpec.describe MeasurementImport do
  it "saves the measurements returned by the API" do
    house = House.create!(name: "Test house")
    Consumer.create!(house: house, name: "Flat 1", metering_location_id: "DE0000000000000000000000000000001", market_location_id: "5000000001")

    api_response = [
      { "values" => [ { "value" => 0.5, "quality" => "TRUE", "startDate" => "2026-09-01T00:00:00+02:00", "endDate" => "2026-09-01T00:15:00+02:00" } ] }
    ]
    allow(MeasurementApi).to receive(:get_data).and_return(api_response)

    MeasurementImport.call(Date.new(2026, 9, 1)..Date.new(2026, 9, 1))

    expect(Measurement.count).to eq(2)
    expect(Measurement.first.value_kwh).to eq(0.5)
  end
end
