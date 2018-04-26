class AddFieldsToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :short_description, :text
    add_column :products, :price, :decimal
    add_column :products, :weight, :decimal
    add_column :products, :field_3, :text
    add_column :products, :field_4, :text
    add_column :products, :related_product_id, :integer
  end
end
