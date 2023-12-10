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

ActiveRecord::Schema.define(version: 2) do
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
end
