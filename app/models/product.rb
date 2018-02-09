class Product < ApplicationRecord
    has_attached_file :image, styles: { large: "800x800>", medium: "500x500>", thumb: "150x150>" }
    validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/
    before_destroy :delete_image
  
    def delete_image
        self.image.destroy
    end
end
