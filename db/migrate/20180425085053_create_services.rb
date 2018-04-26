class CreateServices < ActiveRecord::Migration[5.2]
    def change
        create_table :services do |t|
        t.text :header
        t.text :description
        t.text :dropdown_header
        t.integer :number
        t.text :background_color
        t.text :text_color

        t.timestamps
        end
    end
end