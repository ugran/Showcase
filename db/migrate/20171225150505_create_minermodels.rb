class CreateMinermodels < ActiveRecord::Migration[5.1]
  def change
    create_table :minermodels do |t|
      t.string :name
      t.decimal :speed
      t.string :unit
      t.string :algo

      t.timestamps
    end
  end
end
