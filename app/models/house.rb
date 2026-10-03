# Correspond to a building equiped with solar / GGV

class House < ApplicationRecord
  has_many :consumers
  
  validates :name, presence: true
end
