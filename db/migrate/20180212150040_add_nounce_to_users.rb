class AddNounceToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :nounce, :integer
  end
end
