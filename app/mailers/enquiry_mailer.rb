class EnquiryMailer < ApplicationMailer
    default from: 'admin@cryptografs.com'

    def send_enquiry(product_name_final, product_quantity_final, product_price_final, optional_product_name_final, optional_product_price_final, enquiry_email, enquiry_comment)
        @product_name_final = product_name_final
        @product_quantity_final = product_quantity_final
        @product_price_final = product_price_final
        @optional_product_name_final = optional_product_name_final
        @optional_product_price_final = optional_product_price_final
        @enquiry_email = enquiry_email
        @enquiry_comment = enquiry_comment
        mail(to: 'info@cryptografs.com', subject: 'Enquiry Form')
    end
end