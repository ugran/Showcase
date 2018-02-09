class ContactMailer < ApplicationMailer
    default from: 'admin@cryptografs.com'

    def contact_email(name,email,phone,message)
        @name = name
        @email = email
        @phone = phone
        @message = message
        mail(to: 'info@cryptografs.com', subject: 'Contact Form')
    end
end
