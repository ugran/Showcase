class ServiceEnquiryMailer < ApplicationMailer
    default from: 'admin@cryptografs.com'

    def send_enquiry(first_name_service, last_name_service, phone_number_service, email_service, comment_service)
        @first_name_service = first_name_service
        @last_name_service = last_name_service
        @phone_number_service = phone_number_service
        @email_service = email_service
        @comment_service = comment_service
        mail(to: 'info@cryptografs.com', subject: 'Service Enquiry Form')
    end
end
