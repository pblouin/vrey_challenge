class Consumer < ApplicationRecord
  include Consumption

  belongs_to :house
  has_many :metering_measurements, class_name: "Measurement", primary_key: :metering_location_id, foreign_key: :location_id
  has_many :market_measurements, class_name: "Measurement", primary_key: :market_location_id, foreign_key: :location_id

  validates :name, presence: true

  validates :market_location_id, presence: true, uniqueness: true, length: { is: 10 }, numericality: { only_integer: true }
  validates :metering_location_id, presence: true, uniqueness: true, length: { is: 33 }
end
