class CreateXrpHistories < ActiveRecord::Migration[5.1]
  def change
    create_table :xrp_histories do |t|
      t.decimal :price

      t.timestamps
    end
  end
end
