class House < ApplicationRecord
  has_many :consumers

  validates :name, presence: true
end
