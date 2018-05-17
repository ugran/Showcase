class CreatePayouts < ActiveRecord::Migration[5.2]
  def change
    create_table :payouts do |t|
      t.integer :user_id
      t.decimal :btc
      t.decimal :ltc
      t.decimal :eth
      t.decimal :sia
      t.decimal :zec
      t.decimal :dash

      t.timestamps
    end
    add_index :payouts, :user_id
  end
end
