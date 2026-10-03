# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_10_03_204226) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "consumers", force: :cascade do |t|
    t.bigint "house_id", null: false
    t.string "name"
    t.string "market_location_id"
    t.string "metering_location_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["house_id"], name: "index_consumers_on_house_id"
    t.index ["market_location_id"], name: "index_consumers_on_market_location_id", unique: true
    t.index ["metering_location_id"], name: "index_consumers_on_metering_location_id", unique: true
  end

  create_table "houses", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "measurements", force: :cascade do |t|
    t.string "location_id"
    t.datetime "start_date"
    t.datetime "end_date"
    t.decimal "value_kwh"
    t.string "quality"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["location_id", "start_date"], name: "index_measurements_on_location_id_and_start_date", unique: true
  end

  add_foreign_key "consumers", "houses"
end
