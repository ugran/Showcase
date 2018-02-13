class AddPoloniexSecretToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :poloniex_secret, :string
  end
end
