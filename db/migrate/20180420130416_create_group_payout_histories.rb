class CreateGroupPayoutHistories < ActiveRecord::Migration[5.2]
  def change
    create_table :group_payout_histories do |t|
      t.integer :group_id
      t.decimal :btc_before
      t.decimal :btc_after
      t.decimal :ltc_before
      t.decimal :ltc_after
      t.decimal :btc_total_payout
      t.decimal :ltc_total_payout
      t.json :payouts

      t.timestamps
    end
    add_index :group_payout_histories, :group_id
  end
end
