require "rails_helper"

RSpec.describe "Houses", type: :request do
  let(:house) { House.create!(name: "Kopenhagener Str. 1") }
  let!(:flat) { Consumer.create!(house: house, name: "Flat 1", metering_location_id: "total-1", market_location_id: "grid-1") }

  it "lists the houses" do
    get root_path

    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Kopenhagener Str. 1")
  end

  it "shows the figures of the house for a month" do
    start_date = Time.zone.parse("2026-09-01 12:00")
    Measurement.create!(location_id: "total-1", start_date: start_date, end_date: start_date + 15.minutes, value_kwh: 10)
    Measurement.create!(location_id: "grid-1", start_date: start_date, end_date: start_date + 15.minutes, value_kwh: 4)

    get house_path(house, month: "2026-09-01")

    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Solar share")
    expect(response.body).to include("60%")
  end

  it "shows a message when there is no data" do
    get house_path(house)

    expect(response.body).to include("No data imported yet")
  end

  it "redirects to the house page when the date is invalid" do
    get house_path(house, day: "not-a-date")

    expect(response).to redirect_to(house_path(house))
  end
end
