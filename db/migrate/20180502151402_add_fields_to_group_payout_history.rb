class AddFieldsToGroupPayoutHistory < ActiveRecord::Migration[5.2]
  def change
    add_column :group_payout_histories, :total_btc_hash, :decimal
    add_column :group_payout_histories, :total_ltc_hash, :decimal
  end
end
