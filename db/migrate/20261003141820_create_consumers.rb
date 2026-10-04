class CreateConsumers < ActiveRecord::Migration[8.1]
  def change
    create_table :consumers do |t|
      t.references :house, null: false, foreign_key: true
      t.string :name
      t.string :market_location_id
      t.string :metering_location_id

      t.timestamps
    end

    add_index :consumers, :market_location_id, unique: true
    add_index :consumers, :metering_location_id, unique: true
  end
end
