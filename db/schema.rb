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

ActiveRecord::Schema.define(version: 20171225150615) do

  create_table "groups", force: :cascade do |t|
    t.string "name"
    t.string "nicehash_wallet"
    t.string "btc_wallet"
    t.string "eth_wallet"
    t.string "ltc_wallet"
    t.string "api_key"
    t.string "litecoinpool_api_key"
    t.string "slushpool_api_key"
    t.boolean "nicehash", default: false
    t.string "api_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "minermodels", force: :cascade do |t|
    t.string "name"
    t.decimal "speed"
    t.string "unit"
    t.string "algo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "miners", force: :cascade do |t|
    t.integer "user_id"
    t.string "worker_name"
    t.string "hashrate"
    t.string "avg_hashrate"
    t.string "temperature"
    t.string "algorithm"
    t.string "coin"
    t.string "accepted"
    t.string "rejected"
    t.string "hw_errors"
    t.string "status"
    t.string "mining_time"
    t.string "miner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "minermodel_id"
    t.index ["minermodel_id"], name: "index_miners_on_minermodel_id"
    t.index ["user_id"], name: "index_miners_on_user_id"
  end

  create_table "nsalgos", force: :cascade do |t|
    t.integer "number"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.boolean "admin", default: false
    t.boolean "active", default: false
    t.string "nicehash_wallet"
    t.string "btc_wallet"
    t.string "eth_wallet"
    t.string "ltc_wallet"
    t.string "api_key"
    t.string "balance"
    t.string "percent_fee"
    t.string "fixed_fee"
    t.string "litecoinpool_api_key"
    t.string "slushpool_api_key"
    t.boolean "nicehash", default: false
    t.integer "group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "api_id"
    t.string "name"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["group_id"], name: "index_users_on_group_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
