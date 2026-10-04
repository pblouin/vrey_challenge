require "rails_helper"

RSpec.describe Consumer do
  let(:house) { House.create!(name: "Test house") }

  it "is valid with a 10-digit market location and a 33-character metering location" do
    consumer = Consumer.new(house: house, name: "Flat 1", market_location_id: "5123456789", metering_location_id: "DE0001234567890000000000000000012")

    expect(consumer).to be_valid
  end

  it "is not valid with a wrong market location" do
    consumer = Consumer.new(house: house, name: "Flat 1", market_location_id: "12345", metering_location_id: "DE0001234567890000000000000000012")

    expect(consumer).not_to be_valid
  end
end
