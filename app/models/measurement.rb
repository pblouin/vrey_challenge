class Measurement < ApplicationRecord
  validates :location_id, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :value_kwh, presence: true
end
