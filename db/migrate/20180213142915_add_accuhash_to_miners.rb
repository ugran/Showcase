class AddAccuhashToMiners < ActiveRecord::Migration[5.2]
  def change
    add_column :miners, :accuhash, :decimal, :null => false, :default => 0
  end
end
