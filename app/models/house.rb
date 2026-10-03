# Correspond to a building equiped with solar / GGV

class House < ApplicationRecord
  validates :name, presence: true
end
