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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120523201156) do

  create_table "amenities", :force => true do |t|
    t.string   "name"
    t.integer  "priority"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "amenities_listings", :id => false, :force => true do |t|
    t.integer "amenity_id"
    t.integer "listing_id"
  end

  add_index "amenities_listings", ["amenity_id", "listing_id"], :name => "index_amenities_listings_on_amenity_id_and_listing_id"

  create_table "bookings", :force => true do |t|
    t.integer  "user_id"
    t.integer  "listing_id"
    t.date     "begin_date"
    t.date     "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cancellation_policies", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cities", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "listings", :force => true do |t|
    t.integer  "user_id"
    t.integer  "neighborhood_id"
    t.string   "title"
    t.integer  "property_type"
    t.integer  "max_guests"
    t.integer  "rooms"
    t.boolean  "certified"
    t.integer  "extra_cost"
    t.integer  "daily_price"
    t.integer  "weekly_price"
    t.integer  "monthly_price"
    t.integer  "size"
    t.integer  "cancellation_policy_id"
    t.integer  "checkin"
    t.integer  "checkout"
    t.integer  "deposit"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "neighborhoods", :force => true do |t|
    t.integer  "city_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "profiles", :force => true do |t|
    t.integer  "listing_id"
    t.string   "language"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ratings", :force => true do |t|
    t.integer  "overall"
    t.integer  "accuracy"
    t.integer  "cleanliness"
    t.integer  "checkin"
    t.integer  "communication"
    t.integer  "location"
    t.integer  "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
