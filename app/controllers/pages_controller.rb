class PagesController < ApplicationController
    before_action :authenticate_admin, only: [:admin]
    require 'net/http'
    require "open-uri"

    def index

    end

    def mining
        if user_signed_in?
            if current_user.miners.present? && current_user.active?
                awesome = URI.parse('http://192.168.80.62:17790/api/miners?key=19a23495fd3e42c4b62e6bca34a90bb1').read
                awesome_info = JSON.parse(awesome, :symbolize_names => true)
                miners_array = []
                awesome_info[:groupList].each do |g|
                    group_miners = g[:minerList]
                    group_miners_array = []
                    group_miners.each do |m|
                        hash = {}
                        hash[:temperature] = m[:temperature]
                        hash[:hashrate] = m[:speedInfo][:hashrate]
                        hash[:avg_hashrate] = m[:speedInfo][:avgHashrate]
                        m[:poolList].each_with_index do |p,i|
                            if i == 0
                                hash[:wallet] = p[:additionalInfo][:worker].split('.')[0]
                                hash[:worker] = p[:additionalInfo][:worker].split('.')[1]
                            end
                        end
                        miners_array.push(hash)
                    end
                end
                miners_array.each do |t|
                    user = User.find_by(nicehash_wallet: t[:wallet])
                    if user.present?
                        user.miners.each do |t|
                            miner_info = miners_array.select{ |m| m[:worker] == t.worker_name}
                            t.update(hashrate: miner_info.first[:hashrate], avg_hashrate: miner_info.first[:avg_hashrate], temperature: miner_info.first[:temperature], )
                        end
                    end
                end
                @miners = current_user.miners
                @nicehash_current = JSON.parse(URI.parse('https://api.nicehash.com/api?method=stats.provider&addr='+current_user.nicehash_wallet).read, :symbolize_names => true)
                @profitability = JSON.parse(URI.parse('https://api.nicehash.com/api?method=stats.global.24h').read, :symbolize_names => true)
                @btc_price = JSON.parse(URI.parse('https://api.coindesk.com/v1/bpi/currentprice.json').read, :symbolize_names => true)[:bpi][:USD][:rate_float]
                @balance = JSON.parse(URI.parse('https://api.nicehash.com/api?method=balance&id='+current_user.api_id+'&key='+current_user.api_key).read, :symbolize_names => true)
                @key = current_user.api_key
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
        elsif params[:edit_user].present?
            @edit_user = User.find(params[:edit_user].to_i)
            @miners = @edit_user.miners
        elsif params[:edit_user_id].present?
            User.find(params[:edit_user_id].to_i).update(nicehash_wallet: params[:nicehash_wallet], api_id: params[:api_id], api_key: params[:api_key], percent_fee: params[:percent_fee], fixed_fee: params[:fixed_fee])
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
            redirect_back fallback_location: admin_path, notice: "Activation Status Changed."
        elsif params[:add_miner_to_user].present? && params[:worker_name].present? && params[:algorithm].present?
            @edit_user = User.find(params[:add_miner_to_user].to_i)
            Miner.create(user_id: @edit_user.id, worker_name: params[:worker_name], algorithm: params[:algorithm])
            @miners = @edit_user.miners
            redirect_back fallback_location: admin_path, notice: "Miner Added."
        elsif params[:delete_miner].present?
            miner = Miner.find(params[:delete_miner].to_i)
            @edit_user = miner.user
            miner.delete
            @miners = @edit_user.miners
        else

        end
    end

private

    helper_method :resource_name, :resource, :devise_mapping, :resource_class
    
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