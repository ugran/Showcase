class AddGeorgianFieldsToServices < ActiveRecord::Migration[5.2]
  def change
    add_column :services, :header_geo, :text
    add_column :services, :description_geo, :text
    add_column :services, :dropdown_header_geo, :text
  end
end
