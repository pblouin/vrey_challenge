module HousesHelper
  FLAT_COLORS = [ "#4a3aa7", "#008300", "#eda100" ]

  def house_page_path(house, changes)
    current = { month: params[:month], day: params[:day], flat_id: params[:flat_id], per_flat: params[:per_flat] }

    house_path(house, current.merge(changes))
  end

  def percentage(part, whole)
    whole.zero? ? 0 : part / whole * 100
  end

  def chart_data(house_or_flat, period, daily, per_flat)
    if per_flat
      per_flat_chart_data(house_or_flat, period, daily)
    else
      solar_grid_chart_data(house_or_flat, period, daily)
    end
  end

  def solar_grid_chart_data(house_or_flat, period, daily)
    total_kwh = kwh_per_bar(house_or_flat.metering_measurements, period, daily)
    grid_kwh = kwh_per_bar(house_or_flat.market_measurements, period, daily)
    bar_times = total_kwh.keys

    {
      labels: chart_labels(bar_times, daily),
      datasets: [
        { label: "Solar", data: bar_times.map { |time| (total_kwh[time] - grid_kwh[time]).to_f }, backgroundColor: "#f25244" },
        { label: "Grid", data: bar_times.map { |time| grid_kwh[time].to_f }, backgroundColor: "#2a78d6" }
      ]
    }
  end

  def per_flat_chart_data(house, period, daily)
    bar_times = kwh_per_bar(house.metering_measurements, period, daily).keys

    datasets = house.consumers.each_with_index.map do |flat, index|
      flat_kwh = kwh_per_bar(flat.metering_measurements, period, daily)

      { label: flat.name, data: bar_times.map { |time| flat_kwh[time].to_f }, backgroundColor: FLAT_COLORS[index] }
    end

    { labels: chart_labels(bar_times, daily), datasets: datasets }
  end

  def chart_labels(bar_times, daily)
    if daily
      bar_times.map { |time| time.strftime("%H:%M") }
    else
      bar_times.map { |time| time.day }
    end
  end

  # kWh for each bar of the chart: one bar per quarter-hour (daily view) or per day (monthly view)
  def kwh_per_bar(measurements, period, daily)
    kwh = Hash.new(0)

    measurements.between(period).order(:start_date).pluck(:start_date, :value_kwh).each do |start_date, value_kwh|
      if daily
        kwh[start_date] += value_kwh
      else
        kwh[start_date.to_date] += value_kwh
      end
    end

    kwh
  end
end
