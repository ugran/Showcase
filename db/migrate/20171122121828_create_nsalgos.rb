class CreateNsalgos < ActiveRecord::Migration[5.1]
  def change
    create_table :nsalgos do |t|
      t.integer :number
      t.string :name

      t.timestamps
    end
  end
end
