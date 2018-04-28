class FacilityCarousel < ApplicationRecord
    has_attached_file :image, styles: { medium: "800x800>", thumb: "100x100>" }
    validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/
    before_destroy :delete_image
  
    def delete_image
        self.image.destroy
    end
end
