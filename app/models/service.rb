class Service < ApplicationRecord
    has_many :service_options
    has_attached_file :image, styles: { medium: "800x800>" }
    validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/
    before_destroy :delete_image

    def delete_image
        self.image.destroy
    end
end