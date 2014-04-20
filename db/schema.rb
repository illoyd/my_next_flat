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

ActiveRecord::Schema.define(version: 20140419141947) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "alerts", force: true do |t|
    t.integer  "search_id"
    t.string   "contact",        null: false
    t.datetime "last_performed", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "alerts", ["search_id"], name: "index_alerts_on_search_id", using: :btree

  create_table "criteria", force: true do |t|
    t.integer  "search_id"
    t.string   "type",                         null: false
    t.boolean  "include_let",  default: false, null: false
    t.boolean  "include_sold", default: false, null: false
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

  add_index "criteria", ["search_id"], name: "index_criteria_on_search_id", using: :btree

  create_table "locations", force: true do |t|
    t.integer  "search_id"
    t.string   "type"
    t.string   "area",                     null: false
    t.string   "country"
    t.float    "radius",     default: 0.0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "latitude"
    t.float    "longitude"
  end

  add_index "locations", ["search_id"], name: "index_locations_on_search_id", using: :btree

  create_table "point_of_interests", force: true do |t|
    t.string   "name"
    t.string   "kind"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "zones",      default: [], array: true
    t.string   "lines",      default: [], array: true
  end

  add_index "point_of_interests", ["lines"], name: "index_point_of_interests_on_lines", using: :gin
  add_index "point_of_interests", ["zones"], name: "index_point_of_interests_on_zones", using: :gin

  create_table "searches", force: true do |t|
    t.integer  "user_id"
    t.string   "name",                            null: false
    t.boolean  "active",       default: true,     null: false
    t.datetime "last_run_at"
    t.datetime "next_run_at"
    t.text     "schedule"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "alert_method", default: "ignore"
    t.integer  "top_n",        default: 1
  end

  add_index "searches", ["user_id"], name: "index_searches_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.boolean  "guest",                  default: false
    t.string   "twitter_uid"
    t.string   "twitter_handle"
    t.string   "profile_image_url"
    t.boolean  "real_email",             default: true
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
