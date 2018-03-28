class CreatePersonalInformations < ActiveRecord::Migration[5.2]
  def change
    create_table :personal_informations do |t|
      t.text :first_name
      t.text :last_name
      t.text :address
      t.text :country
      t.text :phone_number
      t.text :comment
      t.integer :user_id

      t.timestamps
    end
    add_index :personal_informations, :user_id
  end
end
