module Consumption
  def total_kwh(period)
    metering_measurements.between(period).sum(:value_kwh)
  end

  def grid_kwh(period)
    market_measurements.between(period).sum(:value_kwh)
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
