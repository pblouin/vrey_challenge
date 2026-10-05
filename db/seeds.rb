# Only seed an empty database, so a deploy never erases imported data
return if House.exists?

kopenhagener = House.create!(name: "Kopenhagener Str. 1")
Consumer.create!(house: kopenhagener, name: "Flat 1", market_location_id: "5123456789", metering_location_id: "DE0001234567890000000000000000012")
Consumer.create!(house: kopenhagener, name: "Flat 2", market_location_id: "5123456790", metering_location_id: "DE0001234567890000000000000000013")
Consumer.create!(house: kopenhagener, name: "Flat 3", market_location_id: "5123456791", metering_location_id: "DE0001234567890000000000000000014")

danziger = House.create!(name: "Danziger Str. 2")
Consumer.create!(house: danziger, name: "Flat 1", market_location_id: "5123456792", metering_location_id: "DE0001234567890000000000000000015")
Consumer.create!(house: danziger, name: "Flat 2", market_location_id: "5123456793", metering_location_id: "DE0001234567890000000000000000016")

stargarder = House.create!(name: "Stargarder Str. 3")
Consumer.create!(house: stargarder, name: "Flat 1", market_location_id: "5123456794", metering_location_id: "DE0001234567890000000000000000017")
Consumer.create!(house: stargarder, name: "Flat 2", market_location_id: "5123456795", metering_location_id: "DE0001234567890000000000000000018")
Consumer.create!(house: stargarder, name: "Flat 3", market_location_id: "5123456796", metering_location_id: "DE0001234567890000000000000000019")

# Import the last months: 3 previous months + current month until today
first_day = Date.current.prev_month(3).beginning_of_month
MeasurementImport.call(first_day..Date.current)
