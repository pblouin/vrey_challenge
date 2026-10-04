require "rails_helper"

RSpec.describe MeasurementImport do
  let(:house) { House.create!(name: "Test house") }
  let!(:flat) { Consumer.create!(house: house, name: "Flat 1", metering_location_id: "total-1", market_location_id: "grid-1") }
  let(:period) { Date.new(2026, 9, 1)..Date.new(2026, 9, 1) }

  # Same format as the API: one entry per day, with a value per quarter-hour
  def api_response(value)
    [
      {
        "values" => [
          { "value" => value, "quality" => "TRUE", "startDate" => "2026-09-01T00:00:00+02:00", "endDate" => "2026-09-01T00:15:00+02:00" },
          { "value" => value, "quality" => "TRUE", "startDate" => "2026-09-01T00:15:00+02:00", "endDate" => "2026-09-01T00:30:00+02:00" }
        ]
      }
    ]
  end

  it "saves the measurements of both meters of each flat" do
    allow(MeasurementApi).to receive(:get_data).and_return(api_response(0.5))

    MeasurementImport.call(period)

    expect(Measurement.where(location_id: "total-1").count).to eq(2)
    expect(Measurement.where(location_id: "grid-1").count).to eq(2)

    measurement = Measurement.find_by(location_id: "total-1", start_date: Time.zone.parse("2026-09-01 00:00"))
    expect(measurement.value_kwh).to eq(0.5)
    expect(measurement.quality).to eq("TRUE")
  end

  it "updates the values instead of duplicating them when imported twice" do
    allow(MeasurementApi).to receive(:get_data).and_return(api_response(0.5))
    MeasurementImport.call(period)

    allow(MeasurementApi).to receive(:get_data).and_return(api_response(0.8))
    MeasurementImport.call(period)

    expect(Measurement.where(location_id: "total-1").count).to eq(2)
    expect(Measurement.where(location_id: "total-1").pluck(:value_kwh)).to all(eq(0.8))
  end
end
