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

ActiveRecord::Schema.define(version: 2018_04_20_130416) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "btc_histories", force: :cascade do |t|
    t.decimal "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "eth_histories", force: :cascade do |t|
    t.decimal "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "group_payout_histories", force: :cascade do |t|
    t.integer "group_id"
    t.decimal "btc_before"
    t.decimal "btc_after"
    t.decimal "ltc_before"
    t.decimal "ltc_after"
    t.decimal "btc_total_payout"
    t.decimal "ltc_total_payout"
    t.json "payouts"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_group_payout_histories_on_group_id"
  end

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
    t.integer "nounce", default: 0, null: false
    t.string "poloniex_key"
    t.string "poloniex_secret"
    t.decimal "accubtc", default: "0.0", null: false
    t.decimal "accultc", default: "0.0", null: false
    t.decimal "accueth", default: "0.0", null: false
    t.decimal "accudash", default: "0.0", null: false
    t.decimal "accusia", default: "0.0", null: false
    t.json "unpaid_balances"
  end

  create_table "litecoinpoolstats", force: :cascade do |t|
    t.integer "user_id"
    t.integer "group_id"
    t.decimal "total_hashrate", default: "0.0", null: false
    t.decimal "total_rewards", default: "0.0", null: false
    t.decimal "paid_rewards", default: "0.0", null: false
    t.decimal "unpaid_rewards", default: "0.0", null: false
    t.decimal "expected_rewards", default: "0.0", null: false
    t.decimal "past_24_rewards", default: "0.0", null: false
    t.json "hashrate_distribution"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_litecoinpoolstats_on_group_id"
    t.index ["user_id"], name: "index_litecoinpoolstats_on_user_id"
  end

  create_table "ltc_histories", force: :cascade do |t|
    t.decimal "price"
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
    t.decimal "accuhash", default: "0.0", null: false
    t.decimal "prevhash", default: "0.0", null: false
    t.index ["minermodel_id"], name: "index_miners_on_minermodel_id"
    t.index ["user_id"], name: "index_miners_on_user_id"
    t.index ["worker_name"], name: "index_miners_on_worker_name", unique: true
  end

  create_table "nsalgos", force: :cascade do |t|
    t.integer "number"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "personal_informations", force: :cascade do |t|
    t.text "first_name"
    t.text "last_name"
    t.text "address"
    t.text "country"
    t.text "phone_number"
    t.text "comment"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "status"
    t.index ["user_id"], name: "index_personal_informations_on_user_id"
  end

  create_table "products", force: :cascade do |t|
    t.text "name"
    t.text "specifications"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "category"
    t.string "image_file_name"
    t.string "image_content_type"
    t.integer "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "slushpoolstats", force: :cascade do |t|
    t.integer "user_id"
    t.integer "group_id"
    t.decimal "total_hashrate", default: "0.0", null: false
    t.decimal "confirmed_reward", default: "0.0", null: false
    t.decimal "unconfirmed_reward", default: "0.0", null: false
    t.decimal "estimated_reward", default: "0.0", null: false
    t.json "hashrate_distribution"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_slushpoolstats_on_group_id"
    t.index ["user_id"], name: "index_slushpoolstats_on_user_id"
  end

  create_table "user_balances", force: :cascade do |t|
    t.integer "user_id"
    t.decimal "paid_btc", default: "0.0", null: false
    t.decimal "paid_ltc", default: "0.0", null: false
    t.decimal "paid_eth", default: "0.0", null: false
    t.decimal "paid_dash", default: "0.0", null: false
    t.decimal "paid_sia", default: "0.0", null: false
    t.decimal "cur_btc", default: "0.0", null: false
    t.decimal "cur_ltc", default: "0.0", null: false
    t.decimal "cur_eth", default: "0.0", null: false
    t.decimal "cur_dash", default: "0.0", null: false
    t.decimal "cur_sia", default: "0.0", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_balances_on_user_id"
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
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "api_id"
    t.string "name"
    t.string "poloniex_key"
    t.string "poloniex_secret"
    t.integer "nounce", default: 0, null: false
    t.decimal "paid_btc", default: "0.0", null: false
    t.decimal "paid_ltc", default: "0.0", null: false
    t.decimal "paid_eth", default: "0.0", null: false
    t.decimal "paid_dash", default: "0.0", null: false
    t.decimal "paid_sia", default: "0.0", null: false
    t.decimal "cur_btc", default: "0.0", null: false
    t.decimal "cur_ltc", default: "0.0", null: false
    t.decimal "cur_eth", default: "0.0", null: false
    t.decimal "cur_dash", default: "0.0", null: false
    t.decimal "cur_sia", default: "0.0", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["group_id"], name: "index_users_on_group_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "xrp_histories", force: :cascade do |t|
    t.decimal "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
