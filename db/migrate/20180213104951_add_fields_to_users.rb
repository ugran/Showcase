class AddFieldsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :paid_btc, :decimal, :null => false, :default => 0
    add_column :users, :paid_ltc, :decimal, :null => false, :default => 0
    add_column :users, :paid_eth, :decimal, :null => false, :default => 0
    add_column :users, :paid_dash, :decimal, :null => false, :default => 0
    add_column :users, :paid_sia, :decimal, :null => false, :default => 0
  end
end
