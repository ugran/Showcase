class AddGeorgiaFieldsToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :name_geo, :text
    add_column :products, :specifications_geo, :text
    add_column :products, :description_geo, :text
    add_column :products, :short_description_geo, :text
    add_column :products, :field_3_geo, :text
    add_column :products, :field_4_geo, :text
  end
end
