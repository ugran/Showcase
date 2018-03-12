class AddNounceToGroups < ActiveRecord::Migration[5.2]
  def change
    add_column :groups, :nounce, :integer, :null => false, :default => 0
    add_column :groups, :poloniex_key, :string
    add_column :groups, :poloniex_secret, :string
    add_column :groups, :accubtc, :decimal, :null => false, :default => 0
    add_column :groups, :accultc, :decimal, :null => false, :default => 0
    add_column :groups, :accueth, :decimal, :null => false, :default => 0
    add_column :groups, :accudash, :decimal, :null => false, :default => 0
    add_column :groups, :accusia, :decimal, :null => false, :default => 0
    add_column :groups, :unpaid_balances, :json
  end
end
