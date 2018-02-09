class AddCategoryToProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :category, :integer
  end
end
