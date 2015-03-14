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

ActiveRecord::Schema.define(version: 20150314062837) do

  create_table "memberships", force: :cascade do |t|
    t.integer  "user_id",                  limit: 4
    t.datetime "valid_from"
    t.integer  "duration",                 limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "express_token",            limit: 255
    t.string   "express_payer_id",         limit: 255
    t.datetime "purchase_date"
    t.string   "paypal_payer_id",          limit: 255
    t.string   "paypal_email",             limit: 255
    t.string   "paypal_first_name",        limit: 255
    t.string   "paypal_last_name",         limit: 255
    t.string   "paypal_profile_id",        limit: 255
    t.string   "paypal_street1",           limit: 255
    t.string   "paypal_street2",           limit: 255
    t.string   "paypal_city_name",         limit: 255
    t.string   "paypal_state_or_province", limit: 255
    t.string   "paypal_country_name",      limit: 255
    t.string   "paypal_country_code",      limit: 255
    t.string   "paypal_postal_code",       limit: 255
    t.integer  "price_paid",               limit: 4
    t.boolean  "concession",               limit: 1
    t.integer  "refund",                   limit: 4
    t.datetime "cancellation_date"
  end

  create_table "pages", force: :cascade do |t|
    t.string   "title",      limit: 255
    t.string   "permalink",  limit: 255
    t.text     "body",       limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pages", ["permalink"], name: "index_pages_on_permalink", using: :btree

  create_table "payment_notifications", force: :cascade do |t|
    t.text     "params",           limit: 65535
    t.string   "status",           limit: 255
    t.string   "transaction_id",   limit: 255
    t.string   "transaction_type", limit: 255
    t.integer  "user_id",          limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255,   default: "", null: false
    t.string   "encrypted_password",     limit: 255,   default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,     default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username",               limit: 255
    t.boolean  "admin",                  limit: 1
    t.text     "website",                limit: 65535
    t.text     "about",                  limit: 65535
    t.binary   "nfc_atr",                limit: 65535
    t.binary   "nfc_id",                 limit: 65535
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
