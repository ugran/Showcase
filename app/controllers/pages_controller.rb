class PagesController < ApplicationController
    before_action :authenticate_admin, only: [:admin]
    helper_method :resource_name, :resource, :devise_mapping, :resource_class
    require 'net/http'
    require "open-uri"
    require "uri"

    def index
        
    end

    def dashboard
        if user_signed_in?
            if current_user.active?
                #awesome = URI.parse('http://192.168.80.51:17790/api/miners?key=19a23495fd3e42c4b62e6bca34a90bb1').read
                #awesome_info = JSON.parse(awesome, :symbolize_names => true)
                #miners_array = []
                #awesome_info[:groupList].each do |g|
                #    group_miners = g[:minerList]
                #    group_miners_array = []
                #    group_miners.each do |m|
                #        hash = {}
                #        hash[:temperature] = m[:temperature]
                #        hash[:hashrate] = m[:speedInfo][:hashrate]
                #        hash[:avg_hashrate] = m[:speedInfo][:avgHashrate]
                #        m[:poolList].each_with_index do |p,i|
                #            if i == 0
                #                hash[:wallet] = p[:additionalInfo][:worker].split('.')[0]
                #                hash[:worker] = p[:additionalInfo][:worker].split('.')[1]
                #            end
                #        end
                #        miners_array.push(hash)
                #    end
                #end
                unless current_user.group.present?   
                    if current_user.nicehash?
                        miners_array.each do |t|
                            user = User.find_by(nicehash_wallet: t[:wallet])
                            if user.present?
                                user.miners.each do |t|
                                    miner_info = miners_array.select{ |m| m[:worker] == t.worker_name}
                                    if miner_info.present?
                                        t.update(hashrate: miner_info.first[:hashrate], avg_hashrate: miner_info.first[:avg_hashrate], temperature: miner_info.first[:temperature])
                                    end
                                end
                            end
                        end
                        @miners = current_user.miners
                        @nicehash_current = JSON.parse(URI.parse('https://api.nicehash.com/api?method=stats.provider&addr='+current_user.nicehash_wallet).read, :symbolize_names => true)
                        @profitability = JSON.parse(URI.parse('https://api.nicehash.com/api?method=stats.global.24h').read, :symbolize_names => true)
                        @btc_price = JSON.parse(URI.parse('https://api.coindesk.com/v1/bpi/currentprice.json').read, :symbolize_names => true)[:bpi][:USD][:rate_float]
                        @balance = JSON.parse(URI.parse('https://api.nicehash.com/api?method=balance&id='+current_user.api_id+'&key='+current_user.api_key).read, :symbolize_names => true)
                        @key = current_user.api_key
                    else
                        #miners_array.each do |t|
                        #    current_user.miners.each do |t|
                        #        miner_info = miners_array.select{ |m| m[:worker] == t.worker_name}
                        #        if miner_info.present?
                        #            t.update(hashrate: miner_info.first[:hashrate], avg_hashrate: #miner_info.first[:avg_hashrate], temperature: miner_info.first[:temperature] )
                        #        end
                        #    end
                        #end
                        @miners = current_user.miners
                        #@awesome = awesome
                        ltc_api = current_user.litecoinpool_api_key
                        slush_api = current_user.slushpool_api_key
                        if current_user.litecoinpool_api_key.present?
                            @ltc = JSON.parse(URI.parse('https://www.litecoinpool.org/api?api_key='+ltc_api).read, :symbolize_names => true)
                        end
                        if current_user.slushpool_api_key.present?
                            @btc = JSON.parse(URI.parse('https://slushpool.com/accounts/profile/json/'+slush_api).read, :symbolize_names => true)
                        end
                        respond_to do |format|
                            format.html
                            format.js
                        end
                    end
                else
                    @group = current_user.group
                end
            end
        end
    end

    def show_user

    end

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
            if params[:group_id].present?
                group_id = nil
            else
                group_id = params[:group_id].to_i
            end
            User.find(params[:edit_user_id].to_i).update(nicehash_wallet: params[:nicehash_wallet], api_id: params[:api_id], api_key: params[:api_key], percent_fee: params[:percent_fee], fixed_fee: params[:fixed_fee], btc_wallet: params[:btc_wallet], eth_wallet: params[:eth_wallet], ltc_wallet: params[:ltc_wallet], group_id: group_id, litecoinpool_api_key: params[:litecoinpool_api_key], slushpool_api_key: params[:slushpool_api_key], name: params[:name])
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
        else

        end
    end

private

    def group_params
        if params[:group].present?
            params.require(:group).permit(:name,:nicehash_wallet,:btc_wallet,:eth_wallet,:ltc_wallet,:api_key,:litecoinpool_api_key,:slushpool_api_key,:nicehash, :api_id, :id)
        end
    end
        
      def resource_name
        :user
      end
     
      def resource
        @resource ||= User.new
      end
    
      def resource_class
        User
      end
     
      def devise_mapping
        @devise_mapping ||= Devise.mappings[:user]
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