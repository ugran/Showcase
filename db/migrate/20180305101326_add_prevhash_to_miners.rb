class AddPrevhashToMiners < ActiveRecord::Migration[5.2]
  def change
    add_column :miners, :prevhash, :decimal, :null => false, :default => 0
  end
end
