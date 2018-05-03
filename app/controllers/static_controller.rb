class StaticController < ApplicationController

    def disable_otp
      if params[:disable_2fa].present? && params[:disable_2fa] == current_user.current_otp
        current_user.otp_required_for_login = false
        current_user.save!
        redirect_back fallback_location: two_factor_authentication_path, notice: "2FA Disabled"
      else
        redirect_back fallback_location: two_factor_authentication_path, notice: "Incorrect authentication key"
      end
    end

    def enable_otp
      current_user.otp_secret = User.generate_otp_secret
      current_user.otp_required_for_login = true
      @codes = current_user.generate_otp_backup_codes!
      current_user.save!
      redirect_back fallback_location: two_factor_authentication_path, notice: "2FA Enabled"
    end

    def two_factor_authentication
        @codes = current_user.otp_backup_codes
    end

    def products
        if params[:asic_miners].present?
            @asic_miners = 1
        elsif params[:gpu_miners].present?
            @gpu_miners = 1
        elsif params[:parts_and_accessories].present?
            @parts_and_accessories = 1
        elsif params[:software].present?
            @software = 1
        elsif params[:product_id].present?
            @this_product = Product.find(params[:product_id].to_i)
        elsif params[:send_enquiry].present?
          EnquiryMailer.send_enquiry(params[:product_name_final], params[:product_quantity_final], params[:product_price_final], params[:optional_product_name_final], params[:optional_product_price_final], params[:email], params[:comment]).deliver_later
        end
        @products_all = Product.all
    end

    def services
        @services_all = Service.all
        if params[:service_id].present?
          @this_service = Service.find(params[:service_id].to_i)
        elsif params[:send_service_enquiry].present?
          ServiceEnquiryMailer.send_enquiry(params[:this_service_header], params[:first_name_service], params[:last_name_service], params[:phone_number_service], params[:email_service], params[:comment_service]).deliver_later
        end
    end

    def our_facility
        @facility_carousels = FacilityCarousel.all
    end

    def about_us

    end

    def contact
        if params[:message].present? && params[:name].present? && params[:email].present? && params[:phone].present?
            if verify_recaptcha
                ContactMailer.contact_email(params[:name], params[:email], params[:phone], params[:message]).deliver_later
            else
                redirect_back fallback_location: contact_path, alert: "Please verify that you are not a robot."
            end
        elsif params[:message].present? || params[:name].present? || params[:email].present? || params[:phone].present?
            redirect_back fallback_location: contact_path, alert: "Please fill in all the fields."
        end
    end

end
