class AddIndexToMiners < ActiveRecord::Migration[5.2]
  def change
    add_index :miners, :worker_name, unique: true
  end
end
