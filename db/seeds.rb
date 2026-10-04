Measurement.delete_all
Consumer.delete_all
House.delete_all

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

# Using last month for seed to have a whole month
last_month = Date.current.prev_month
MeasurementImport.call(last_month.beginning_of_month..last_month.end_of_month)
