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

ActiveRecord::Schema[7.1].define(version: 2026_04_06_232226) do
  create_table "bookings", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "phone"
    t.string "service", null: false
    t.date "date", null: false
    t.string "time_slot", null: false
    t.string "status", default: "pending", null: false
    t.string "stripe_session_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["date", "time_slot"], name: "index_bookings_on_date_and_time_slot"
  end

end
