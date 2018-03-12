class StaticController < ApplicationController

    def products
        if params[:asic_miners].present?
            @asic_miners = 1
        elsif params[:gpu_miners].present?
            @gpu_miners = 1
        elsif params[:parts_and_accessories].present?
            @parts_and_accessories = 1
        elsif params[:software].present?
            @software = 1
        end
        @products_all = Product.all
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