class Measurement < ApplicationRecord
  validates :location_id, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :value_kwh, presence: true

  scope :metering_for, ->(consumers) { where(location_id: consumers.map(&:metering_location_id)) }
  scope :market_for, ->(consumers) { where(location_id: consumers.map(&:market_location_id)) }
end
