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

ActiveRecord::Schema.define(version: 20131120162729) do

  create_table "activities", force: true do |t|
    t.integer  "trackable_id"
    t.string   "trackable_type"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "key"
    t.text     "parameters"
    t.integer  "recipient_id"
    t.string   "recipient_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activities", ["owner_id", "owner_type"], name: "index_activities_on_owner_id_and_owner_type"
  add_index "activities", ["recipient_id", "recipient_type"], name: "index_activities_on_recipient_id_and_recipient_type"
  add_index "activities", ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type"

  create_table "attendances", force: true do |t|
    t.integer  "event_id"
    t.integer  "user_id"
    t.string   "iCalUID"
    t.boolean  "cancel",     default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "attendances", ["event_id", "user_id"], name: "index_attendances_on_event_id_and_user_id", unique: true

  create_table "comments", force: true do |t|
    t.integer  "event_id"
    t.integer  "user_id"
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["event_id"], name: "index_comments_on_event_id"
  add_index "comments", ["user_id"], name: "index_comments_on_user_id"

  create_table "events", force: true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.datetime "start"
    t.datetime "finish"
    t.text     "description"
    t.string   "location"
    t.float    "lat"
    t.float    "lng"
    t.boolean  "private",     default: false
    t.integer  "est_att"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "events", ["lat", "lng"], name: "index_events_on_lat_and_lng"
  add_index "events", ["name"], name: "index_events_on_name"
  add_index "events", ["start"], name: "index_events_on_start"

  create_table "images", force: true do |t|
    t.integer  "event_id"
    t.integer  "user_id"
    t.text     "description"
    t.string   "image_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "images", ["event_id"], name: "index_images_on_event_id"
  add_index "images", ["user_id"], name: "index_images_on_user_id"

  create_table "invites", force: true do |t|
    t.integer  "user_id"
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "invites", ["user_id", "event_id"], name: "index_invites_on_user_id_and_event_id", unique: true

  create_table "relationships", force: true do |t|
    t.integer  "sharee_id"
    t.integer  "sharer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "relationships", ["sharee_id", "sharer_id"], name: "index_relationships_on_sharee_id_and_sharer_id", unique: true

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
    t.integer  "range",                  default: 10
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["lat", "lng"], name: "index_users_on_lat_and_lng"
  add_index "users", ["remember_token"], name: "index_users_on_remember_token"

end
