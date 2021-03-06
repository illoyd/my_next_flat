# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150103104818) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "criteria", force: :cascade do |t|
    t.integer  "example_id"
    t.string   "type",         limit: 255,                 null: false
    t.boolean  "include_let",              default: false, null: false
    t.boolean  "include_sold",             default: false, null: false
    t.boolean  "furnished"
    t.integer  "min_price"
    t.integer  "max_price"
    t.integer  "min_beds"
    t.integer  "max_beds"
    t.integer  "min_baths"
    t.integer  "max_baths"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "criteria", ["example_id"], name: "index_criteria_on_example_id", using: :btree

  create_table "examples", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name",            limit: 255,                    null: false
    t.boolean  "active",                      default: true,     null: false
    t.datetime "last_run_at"
    t.datetime "next_run_at"
    t.text     "schedule"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "alert_method",    limit: 255, default: "ignore"
    t.integer  "top_n",                       default: 1
    t.text     "message"
    t.datetime "last_alerted_at"
    t.string   "type",            limit: 255
  end

  add_index "examples", ["type"], name: "index_examples_on_type", using: :btree
  add_index "examples", ["user_id"], name: "index_examples_on_user_id", using: :btree

  create_table "identities", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "identities", ["user_id"], name: "index_identities_on_user_id", using: :btree

  create_table "locations", force: :cascade do |t|
    t.integer  "example_id"
    t.string   "type",                 limit: 255
    t.string   "area",                 limit: 255,               null: false
    t.string   "country",              limit: 255
    t.float    "radius",                           default: 0.0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "point_of_interest_id"
  end

  add_index "locations", ["example_id"], name: "index_locations_on_example_id", using: :btree
  add_index "locations", ["point_of_interest_id"], name: "index_locations_on_point_of_interest_id", using: :btree

  create_table "point_of_interests", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "kind",       limit: 255
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "zones",                  default: [], array: true
    t.string   "lines",                  default: [], array: true
  end

  add_index "point_of_interests", ["lines"], name: "index_point_of_interests_on_lines", using: :gin
  add_index "point_of_interests", ["zones"], name: "index_point_of_interests_on_zones", using: :gin

  create_table "users", force: :cascade do |t|
    t.string   "name",                 limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",                limit: 255, default: "",    null: false
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                    default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",   limit: 255
    t.string   "last_sign_in_ip",      limit: 255
    t.boolean  "guest",                            default: false
    t.string   "photo_url",            limit: 255
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "big_photo_url"
    t.string   "remember_token"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree

  add_foreign_key "identities", "users"
  add_foreign_key "locations", "point_of_interests"
end
