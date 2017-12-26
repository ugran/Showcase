class AddMinermodelToMiners < ActiveRecord::Migration[5.1]
  def change
    add_column :miners, :minermodel_id, :integer
    add_index :miners, :minermodel_id
  end
end
