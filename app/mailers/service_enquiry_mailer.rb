class ServiceEnquiryMailer < ApplicationMailer
    default from: 'admin@cryptografs.com'

    def send_enquiry(this_service_header, first_name_service, last_name_service, phone_number_service, email_service, comment_service, service_option_name, service_option_selected)
        @this_service_header = this_service_header
        @first_name_service = first_name_service
        @last_name_service = last_name_service
        @phone_number_service = phone_number_service
        @email_service = email_service
        @comment_service = comment_service
        @service_option_name = service_option_name
        @service_option_selected = service_option_selected
        mail(to: 'info@cryptografs.com', subject: 'Service Enquiry Form')
    end
end
