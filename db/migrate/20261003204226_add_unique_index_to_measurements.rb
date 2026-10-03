class AddUniqueIndexToMeasurements < ActiveRecord::Migration[8.1]
  def change
    add_index :measurements, [ :location_id, :start_date ], unique: true
  end
end
