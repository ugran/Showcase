class AddOtherfieldsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :cur_btc, :decimal, :null => false, :default => 0
    add_column :users, :cur_ltc, :decimal, :null => false, :default => 0
    add_column :users, :cur_eth, :decimal, :null => false, :default => 0
    add_column :users, :cur_dash, :decimal, :null => false, :default => 0
    add_column :users, :cur_sia, :decimal, :null => false, :default => 0
  end
end
