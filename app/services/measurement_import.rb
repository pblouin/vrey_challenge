class MeasurementImport
  def self.call(period)
    Consumer.all.each do |consumer|
      import(consumer.market_location_id, period)
      import(consumer.metering_location_id, period)
    end
  end

  def self.import(location_id, period)
    data = MeasurementApi.get_data(location_id, period.first, period.last)

    measurements = []

    data.each do |day|
      day["values"].each do |value|
        measurements << {
          location_id: location_id,
          start_date: Time.parse(value["startDate"]),
          end_date: Time.parse(value["endDate"]),
          value_kwh: value["value"].to_d,
          quality: value["quality"]
        }
      end
    end

    Measurement.upsert_all(measurements, unique_by: [ :location_id, :start_date ])
  end
end
