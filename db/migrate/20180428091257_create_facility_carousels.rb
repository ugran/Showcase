class CreateFacilityCarousels < ActiveRecord::Migration[5.2]
  def change
    create_table :facility_carousels do |t|
      t.text :description
      t.boolean :is_video
      t.text :youtube_link

      t.timestamps
    end
  end
end
