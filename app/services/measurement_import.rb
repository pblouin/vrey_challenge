class MeasurementImport
  def self.call(period)
    client = MeasurementApi.new

    Consumer.all.each do |consumer|
      import(client, consumer.market_location_id, period)
      import(client, consumer.metering_location_id, period)
    end
  end

  def self.import(client, location_id, period)
    data = client.get_data(location_id, period.first, period.last)

    measurements = []

    data.each do |day|
      day["values"].each do |day_value|
        measurements << {
          location_id: location_id,
          start_date: Time.parse(day_value["startDate"]),
          end_date: Time.parse(day_value["endDate"]),
          value_kwh: day_value["value"].to_d,
          quality: day_value["quality"]
        }
      end
    end

    Measurement.upsert_all(measurements, unique_by: [ :location_id, :start_date ])
  end
end
