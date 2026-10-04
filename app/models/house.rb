class House < ApplicationRecord
  include Consumption

  has_many :consumers
  has_many :metering_measurements, through: :consumers
  has_many :market_measurements, through: :consumers

  validates :name, presence: true

  # Every month from the first imported month to the last one
  def months_with_data
    return [] unless metering_measurements.exists?

    first_day = metering_measurements.minimum(:start_date).to_date
    last_day = metering_measurements.maximum(:start_date).to_date
    (first_day..last_day).map(&:beginning_of_month).uniq
  end
end
