class Measurement < ApplicationRecord
  validates :location_id, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :value_kwh, presence: true

  scope :between, ->(period) { where(start_date: period.first.beginning_of_day..period.last.end_of_day) }
end
