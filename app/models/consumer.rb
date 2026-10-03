class Consumer < ApplicationRecord
  belongs_to :house

  validates :name, presence: true
  validates :market_location_id, uniqueness: true
  validates :metering_location_id, uniqueness: true
end