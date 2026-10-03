class CreateMeasurements < ActiveRecord::Migration[8.1]
  def change
    create_table :measurements do |t|
      t.string :location_id
      t.datetime :start_date
      t.datetime :end_date
      t.decimal :value_kwh
      t.string :quality

      t.timestamps
    end
  end
end
