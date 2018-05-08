class CreateServiceOptions < ActiveRecord::Migration[5.2]
  def change
    create_table :service_options do |t|
      t.json :options
      t.integer :service_id

      t.timestamps
    end
    add_index :service_options, :service_id
  end
end
