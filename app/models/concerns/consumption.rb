module Consumption
  def total_kwh(period)
    metering_measurements.between(period).sum(:value_kwh)
  end

  def grid_kwh(period)
    market_measurements.between(period).sum(:value_kwh)
  end

  # Days with at least one measurement, in order
  def dates_with_data(period)
    start_dates = metering_measurements.between(period).order(:start_date).pluck(:start_date)
    dates = start_dates.map { |start_date| start_date.to_date }
    dates.uniq
  end

  def solar_kwh(period)
    total_kwh(period) - grid_kwh(period)
  end

  def solar_share(period)
    total = total_kwh(period)
    return 0 if total.zero?

    solar_kwh(period) / total * 100
  end
end
