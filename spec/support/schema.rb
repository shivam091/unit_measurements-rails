# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 9) do
  create_table "cubes", force: :cascade do |t|
    t.decimal "length_quantity", precision: 10, scale: 2
    t.string "length_unit", limit: 12
    t.decimal "width_quantity", precision: 10, scale: 2
    t.string "width_unit", limit: 12
    t.decimal "height_quantity", precision: 10, scale: 2
    t.string "height_unit", limit: 12
  end

  create_table "cube_with_custom_accessors", force: :cascade do |t|
    t.decimal "length_quantity", precision: 10, scale: 2
    t.string "length_uom", limit: 12
    t.decimal "width_value", precision: 10, scale: 2
    t.string "width_unit", limit: 12
    t.decimal "height_value", precision: 10, scale: 2
    t.string "height_uom", limit: 12
  end

  create_table "containers", force: :cascade do |t|
    t.decimal "total_volume_quantity", precision: 10, scale: 2
    t.string "total_volume_unit", limit: 12
    t.decimal "internal_volume_quantity", precision: 10, scale: 2
    t.string "internal_volume_unit", limit: 12
    t.decimal "external_volume_quantity", precision: 10, scale: 2
    t.string "external_volume_unit", limit: 12
  end

  create_table "lands", force: :cascade do |t|
    t.decimal "total_area_quantity", precision: 10, scale: 2
    t.string "total_area_unit", limit: 12
    t.decimal "carpet_area_quantity", precision: 10, scale: 2
    t.string "carpet_area_unit", limit: 12
    t.decimal "buildup_area_quantity", precision: 10, scale: 2
    t.string "buildup_area_unit", limit: 12
  end

  create_table "packages", force: :cascade do |t|
    t.decimal "total_weight_quantity", precision: 10, scale: 2
    t.string "total_weight_unit", limit: 12
    t.decimal "item_weight_quantity", precision: 10, scale: 2
    t.string "item_weight_unit", limit: 12
    t.decimal "package_weight_quantity", precision: 10, scale: 2
    t.string "package_weight_unit", limit: 12
  end

  create_table "substances", force: :cascade do |t|
    t.decimal "total_density_quantity", precision: 10, scale: 2
    t.string "total_density_unit", limit: 12
    t.decimal "internal_density_quantity", precision: 10, scale: 2
    t.string "internal_density_unit", limit: 12
    t.decimal "external_density_quantity", precision: 10, scale: 2
    t.string "external_density_unit", limit: 12
  end

  create_table "weather_reports", force: :cascade do |t|
    t.decimal "average_temperature_quantity", precision: 10, scale: 2
    t.string "average_temperature_unit", limit: 12
    t.decimal "day_temperature_quantity", precision: 10, scale: 2
    t.string "day_temperature_unit", limit: 12
    t.decimal "night_temperature_quantity", precision: 10, scale: 2
    t.string "night_temperature_unit", limit: 12
  end

  create_table "project_timelines", force: :cascade do |t|
    t.decimal "duration_quantity", precision: 10, scale: 2
    t.string "duration_unit", limit: 12
    t.decimal "setup_time_quantity", precision: 10, scale: 2
    t.string "setup_time_unit", limit: 12
    t.decimal "processing_time_quantity", precision: 10, scale: 2
    t.string "processing_time_unit", limit: 12
  end

  create_table "validated_cubes", force: :cascade do |t|
    t.decimal "length_quantity", precision: 10, scale: 2
    t.string "length_unit", limit: 12
    t.decimal "length_true_quantity", precision: 10, scale: 2
    t.string "length_true_unit", limit: 12
    t.decimal "length_presence_quantity", precision: 10, scale: 2
    t.string "length_presence_unit", limit: 12
  end
end
