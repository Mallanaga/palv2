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

ActiveRecord::Schema.define(version: 20131103030608) do

  create_table "attendances", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", force: true do |t|
    t.string   "name"
    t.datetime "start"
    t.text     "why"
    t.string   "location"
    t.float    "lat"
    t.float    "lng"
    t.boolean  "private",    default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "finish"
  end

  add_index "events", ["lat", "lng"], name: "index_events_on_lat_and_lng"
  add_index "events", ["name"], name: "index_events_on_name"
  add_index "events", ["start"], name: "index_events_on_start"

  create_table "invites", force: true do |t|
    t.integer  "user_id"
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "invites", ["event_id"], name: "index_invites_on_event_id"
  add_index "invites", ["user_id"], name: "index_invites_on_user_id"

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "gender",                 default: "F"
    t.date     "dob"
    t.boolean  "admin",                  default: false
    t.string   "location"
    t.float    "lat"
    t.float    "lng"
    t.string   "password_digest"
    t.string   "remember_token"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["lat", "lng"], name: "index_users_on_lat_and_lng"
  add_index "users", ["remember_token"], name: "index_users_on_remember_token"

end
