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

ActiveRecord::Schema.define(version: 20131030083422) do

  create_table "memberships", force: true do |t|
    t.integer  "user_id"
    t.datetime "valid_from"
    t.integer  "duration"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "express_token"
    t.string   "express_payer_id"
    t.datetime "purchase_date"
    t.string   "paypal_payer_id"
    t.string   "paypal_email"
    t.string   "paypal_first_name"
    t.string   "paypal_last_name"
    t.string   "paypal_profile_id"
    t.string   "paypal_street1"
    t.string   "paypal_street2"
    t.string   "paypal_city_name"
    t.string   "paypal_state_or_province"
    t.string   "paypal_country_name"
    t.string   "paypal_country_code"
    t.string   "paypal_postal_code"
    t.integer  "price_paid"
    t.boolean  "concession"
    t.integer  "refund"
    t.datetime "cancellation_date"
  end

  create_table "pages", force: true do |t|
    t.string   "title"
    t.string   "permalink"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pages", ["permalink"], name: "index_pages_on_permalink"

  create_table "payment_notifications", force: true do |t|
    t.text     "params"
    t.string   "status"
    t.string   "transaction_id"
    t.string   "transaction_type"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username"
    t.boolean  "admin"
    t.text     "website"
    t.text     "about"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
