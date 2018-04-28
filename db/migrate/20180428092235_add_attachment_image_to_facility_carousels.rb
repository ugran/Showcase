class AddAttachmentImageToFacilityCarousels < ActiveRecord::Migration[5.2]
  def self.up
    change_table :facility_carousels do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :facility_carousels, :image
  end
end
