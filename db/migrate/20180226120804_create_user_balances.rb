class CreateUserBalances < ActiveRecord::Migration[5.2]
  def change
    create_table :user_balances do |t|
      t.integer :user_id
      t.decimal :paid_btc, :null => false, :default => 0
      t.decimal :paid_ltc, :null => false, :default => 0
      t.decimal :paid_eth, :null => false, :default => 0
      t.decimal :paid_dash, :null => false, :default => 0
      t.decimal :paid_sia, :null => false, :default => 0
      t.decimal :cur_btc, :null => false, :default => 0
      t.decimal :cur_ltc, :null => false, :default => 0
      t.decimal :cur_eth, :null => false, :default => 0
      t.decimal :cur_dash, :null => false, :default => 0
      t.decimal :cur_sia, :null => false, :default => 0

      t.timestamps
    end
    add_index :user_balances, :user_id
  end
end
