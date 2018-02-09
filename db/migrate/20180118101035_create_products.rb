class CreateProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :products do |t|
      t.text :name
      t.text :specifications
      t.text :description

      t.timestamps
    end
  end
end
