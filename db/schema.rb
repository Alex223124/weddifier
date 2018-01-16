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

ActiveRecord::Schema.define(version: 20180108044521) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.index ["email"], name: "index_admins_on_email"
  end

  create_table "guests", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "father_surname"
    t.string "mother_surname"
    t.string "phone"
    t.string "email"
    t.boolean "invited", default: false
    t.bigint "plus_one_id"
    t.bigint "leader_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_guests_on_email"
    t.index ["first_name"], name: "index_guests_on_first_name"
    t.index ["leader_id"], name: "index_guests_on_leader_id"
    t.index ["plus_one_id"], name: "index_guests_on_plus_one_id"
  end

  create_table "invitations", force: :cascade do |t|
    t.string "token"
    t.boolean "fulfilled", default: false
    t.bigint "guest_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guest_id"], name: "index_invitations_on_guest_id"
    t.index ["token"], name: "index_invitations_on_token"
  end

  add_foreign_key "guests", "guests", column: "leader_id"
  add_foreign_key "invitations", "guests"
end
