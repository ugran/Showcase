class AddApiIdToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :api_id, :string
  end
end
