class AdminController < ApplicationController
    before_action :authenticate_admin, only: [:admin]

    def admin
        if params[:user_management] == '1'
            @user_management = 1
            @active_users = User.where(active: true)
            @inactive_users = User.where(active: false)
            @groups = Group.all
        elsif params[:edit_user].present?
            @edit_user = User.find(params[:edit_user].to_i)
            @miners = @edit_user.miners
        elsif params[:edit_user_id].present?
            unless params[:group_id].present?
                group_id = nil
            else
                group_id = params[:group_id].to_i
            end
            User.find(params[:edit_user_id].to_i).update(nicehash_wallet: params[:nicehash_wallet], api_id: params[:api_id], api_key: params[:api_key], percent_fee: params[:percent_fee], fixed_fee: params[:fixed_fee], btc_wallet: params[:btc_wallet], eth_wallet: params[:eth_wallet], ltc_wallet: params[:ltc_wallet], group_id: group_id, litecoinpool_api_key: params[:litecoinpool_api_key], slushpool_api_key: params[:slushpool_api_key], name: params[:name], poloniex_key: params[:poloniex_key], poloniex_secret: params[:poloniex_secret])
            redirect_back fallback_location: admin_path, notice: "User Updated."
        elsif params[:toggle_user_activation].present?
            @user_management = 1
            user = User.find(params[:toggle_user_activation].to_i)
            if user.active == true
                user.update(active: false)
            else
                user.update(active: true)
            end
            @active_users = User.where(active: true)
            @inactive_users = User.where(active: false)
            @groups = Group.all
            redirect_back fallback_location: admin_path, notice: "Activation Status Changed."
        elsif params[:toggle_nicehash].present?
            @user_management = 1
            user = User.find(params[:toggle_nicehash].to_i)
            if user.nicehash == true
                user.update(nicehash: false)
            else
                user.update(nicehash: true)
            end
            @active_users = User.where(active: true)
            @inactive_users = User.where(active: false)
            @groups = Group.all
            redirect_back fallback_location: admin_path, notice: "Nicehash Status Changed."
        elsif params[:toggle_group_nicehash].present?
            @user_management = 1
            group = Group.find(params[:toggle_group_nicehash].to_i)
            if group.nicehash == true
                group.update(nicehash: false)
            else
                group.update(nicehash: true)
            end
            @active_users = User.where(active: true)
            @inactive_users = User.where(active: false)
            @groups = Group.all
            redirect_back fallback_location: admin_path, notice: "Nicehash Status Changed."
        elsif params[:add_miner_to_user].present? && params[:worker_name].present? && params[:minermodel_id].present?
            @edit_user = User.find(params[:add_miner_to_user].to_i)
            miner_model = Minermodel.find(params[:minermodel_id].to_i)
            algo = miner_model.algo
            Miner.create(user_id: @edit_user.id, worker_name: params[:worker_name], algorithm: algo, minermodel_id: params[:minermodel_id].to_i)
            @miners = @edit_user.miners
            redirect_back fallback_location: admin_path, notice: "Miner Added."
        elsif params[:new_group].present?
            @group = Group.new
        elsif params[:edit_group].present?
            @group = Group.find(params[:edit_group].to_i)
        elsif group_params.present?
            unless group_params[:id].present?
                Group.create(group_params)
            else
                group = Group.find(group_params[:id])
                group.update(group_params)
            end
            @user_management = 1
            @active_users = User.where(active: true)
            @inactive_users = User.where(active: false)
            @groups = Group.all
        elsif params[:delete_group].present?
            @user_management = 1
            Group.find(params[:delete_group].to_i).destroy
            @active_users = User.where(active: true)
            @inactive_users = User.where(active: false)
            @groups = Group.all
            redirect_back fallback_location: admin_path, notice: "Group deleted."
        elsif params[:group_payout_history].present?
            @group = Group.find(params[:group_payout_history].to_i)
            @group_payouts = GroupPayoutHistory.where(group_id: @group.id)
        elsif params[:show_payouts].present?
            @payouts = GroupPayoutHistory.find(params[:show_payouts].to_i).payouts
            @group_payout = GroupPayoutHistory.find(params[:show_payouts].to_i)
        elsif params[:delete_miner].present?
            miner = Miner.find(params[:delete_miner].to_i)
            @edit_user = miner.user
            miner.destroy
            @miners = @edit_user.miners
            redirect_back fallback_location: admin_path, notice: "Miner deleted."
        elsif params[:miner_models].present?
            @model_management = 1
            @miner_models = Minermodel.all
            @nsalgos = Nsalgo.all
        elsif params[:unit].present?
            @model_management = 1
            Minermodel.create(name: params[:name], speed: params[:speed].to_f, unit: params[:unit], algo: params[:algo])
            @miner_models = Minermodel.all
            @nsalgos = Nsalgo.all
        elsif params[:number].present?
            @model_management = 1
            Nsalgo.create(name: params[:name], number: params[:number].to_i)
            @miner_models = Minermodel.all
            @nsalgos = Nsalgo.all
        elsif params[:products].present?
            @products = 1
            @products_all = Product.all
            @product = Product.new
        elsif product_params.present?
            unless params[:product][:edit_product_submit].present?
                @products = 1
                Product.create(product_params)
                @products_all = Product.all
                @product = Product.new
                redirect_back fallback_location: admin_path, notice: "Product created."
            else
                Product.find(params[:product][:edit_product_submit]).update(product_params)
                @products = 1
                redirect_to admin_path , notice: "Product updated."
            end
        elsif params[:edit_product].present?
            @edit_product = Product.find(params[:edit_product].to_i)
        elsif params[:delete_product].present?
            Product.find(params[:delete_product].to_i).destroy
            redirect_back fallback_location: admin_path, notice: "Product deleted."
        elsif params[:services].present?
            @services = 1
            @services_all = Service.all
            @service = Service.new
        elsif service_params.present?
            unless params[:service][:edit_service_submit].present?
                Service.create(service_params)
                @services = 1
                @services_all = Service.all
                @service = Service.new
                redirect_back fallback_location: admin_path, notice: "Service created."
            else
                Service.find(params[:service][:edit_service_submit]).update(service_params)
                @services = 1
                redirect_to admin_path , notice: "Service updated."
            end
        elsif params[:edit_service].present?
            @edit_service = Service.find(params[:edit_service].to_i)
        elsif params[:delete_service].present?
            Service.find(params[:delete_service].to_i).destroy
            redirect_back fallback_location: admin_path, notice: "Service deleted."
        elsif params[:facility_carousels].present?
            @facility_carousels = 1
            @facility_carousel = FacilityCarousel.new
            @facility_carousels_all = FacilityCarousel.all
        elsif facility_carousel_params.present?
            FacilityCarousel.create(facility_carousel_params)
            @facility_carousels = 1
            @facility_carousels_all = FacilityCarousel.all
            @facility_carousel = FacilityCarousel.new
            redirect_back fallback_location: admin_path, notice: "Facility Carousel created."
        elsif params[:delete_facility_carousel].present?
            FacilityCarousel.find(params[:delete_facility_carousel].to_i).destroy
            redirect_back fallback_location: admin_path, notice: "Facility_carousel deleted."
        elsif params[:restart_price_job].present?
            ss = Sidekiq::ScheduledSet.new
                jobs = ss.select {|retri| retri.klass == 'PriceWorker' }
            jobs.each(&:delete)
            PriceWorker.perform_in(5.seconds)
        elsif params[:restart_sidekiq].present?
            ss = Sidekiq::ScheduledSet.new
            jobs = ss.select {|retri| retri.klass == 'PoloniexWorker' || retri.klass == 'AwesomeWorker' }
            jobs.each(&:delete)
            
            AwesomeWorker.perform_in(10.seconds)
            Group.all.each do |g|
                if g.poloniex_key.present? && g.poloniex_secret.present?
                    PoloniexWorker.perform_in(30.minutes, g.id)
                end
            end
        elsif params[:restart_pools].present?
            ss = Sidekiq::ScheduledSet.new
            jobs = ss.select {|retri| retri.klass == 'LitecoinpoolWorker' || retri.klass == 'SlushpoolWorker' }
            jobs.each(&:delete)

            Group.all.each do |g|
                if g.litecoinpool_api_key.present? 
                    LitecoinpoolWorker.perform_in(10.seconds, g.id)
                end
                if g.slushpool_api_key.present?
                    SlushpoolWorker.perform_in(10.seconds, g.id)
                end
            end
        else

        end
    end

private

    def group_params
        if params[:group].present?
            params.require(:group).permit(:name,:nicehash_wallet,:btc_wallet,:eth_wallet,:ltc_wallet,:api_key,:litecoinpool_api_key,:slushpool_api_key,:nicehash, :api_id, :id, :poloniex_key, :poloniex_secret)
        end
    end

    def product_params
        if params[:product].present?
            params[:product].permit(:name, :description, :specifications, :category, :image, :short_description, :price, :weight, :field_3, :field_4, :related_product_id)
        end
    end

    def facility_carousel_params
        if params[:facility_carousel].present?
            params[:facility_carousel].permit(:description, :is_video, :description, :youtube_link, :image)
        end
    end

    def service_params
        if params[:service].present?
            params[:service].permit(:number, :header, :dropdown_header, :description, :background_color, :text_color, :image)
        end
    end

    def authenticate_admin
        if user_signed_in?
            unless current_user.admin?
                redirect_to :root
            end
        else
            redirect_to :root
        end
    end
end