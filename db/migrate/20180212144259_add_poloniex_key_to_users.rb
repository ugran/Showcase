class AddPoloniexKeyToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :poloniex_key, :string
  end
end
