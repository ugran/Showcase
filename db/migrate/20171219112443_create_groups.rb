class CreateGroups < ActiveRecord::Migration[5.1]
  def change
    create_table :groups do |t|
      t.string :name
      t.string :nicehash_wallet
      t.string :btc_wallet
      t.string :eth_wallet
      t.string :ltc_wallet
      t.string :api_key
      t.string :litecoinpool_api_key
      t.string :slushpool_api_key
      t.boolean :nicehash, default: false
      t.string :api_id

      t.timestamps
    end
  end
end
