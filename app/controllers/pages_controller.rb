class PagesController < ApplicationController
    helper_method :resource_name, :resource, :devise_mapping, :resource_class
    require 'net/http'
    require "open-uri"
    require "uri"

    def index
        @btc_last_100 = BtcHistory.last(100).map(&:price)
        @eth_last_100 = EthHistory.last(100).map(&:price)
        @ltc_last_100 = LtcHistory.last(100).map(&:price)
        @xrp_last_100 = XrpHistory.last(100).map(&:price)
    end

    def dashboard
        if user_signed_in?
            if current_user.active?
                if current_user.group_id.blank? || current_user.group_id == 0
                    if current_user.nicehash?
                        awesome = URI.parse('http://109.172.247.148:17790/api/miners?key=19a23495fd3e42c4b62e6bca34a90bb1').read
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
                                    miner_info = miners_array.select{ |m| m[:worker] == t.worker_name.gsub(' ', '')}
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
                        awesome = URI.parse('http://109.172.247.148:17790/api/miners?key=19a23495fd3e42c4b62e6bca34a90bb1').read
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
                                        hash[:worker] = p[:additionalInfo][:worker]
                                    end
                                end
                                miners_array.push(hash)
                            end
                        end
                        miners_array.each do |a|
                            current_user.miners.each do |t|
                                miner_info = miners_array.select{ |m| m[:worker] == t.worker_name}
                                if miner_info.present?
                                    t.update(hashrate: miner_info.first[:hashrate], avg_hashrate: miner_info.first[:avg_hashrate], temperature: miner_info.first[:temperature] )
                                end
                            end
                        end
                        @miners = current_user.miners
                        ltc_api = current_user.litecoinpool_api_key
                        slush_api = current_user.slushpool_api_key
                        if current_user.litecoinpool_api_key.present?
                            @ltc = JSON.parse(URI.parse('https://www.litecoinpool.org/api?api_key='+ltc_api).read, :symbolize_names => true)
                        end
                        if current_user.slushpool_api_key.present?
                            @btc = JSON.parse(URI.parse('https://slushpool.com/accounts/profile/json/'+slush_api).read, :symbolize_names => true)
                        end
                        if current_user.nounce.present?
                            nounce = current_user.nounce+1
                        else
                            nounce = 0
                        end
                        respond_to do |format|
                            format.html
                            format.svg  { render :qrcode => request.url, :level => :l, :unit => 10 }
                            format.js
                        end
                    end
                else
                    @group = current_user.group
                    if @group.litecoinpool_api_key.present?
                        @ltc = 1
                    end
                    if @group.slushpool_api_key.present?
                        @btc = 1
                    end
                    @miners = current_user.miners
                end
            else
                if params[:personal_information].present?
                PersonalInformation.create(first_name: params[:first_name], last_name: params[:last_name], phone_number: params[:phone_number], country: params[:country], address: params[:address], comment: params[:comment], user_id: current_user.id, status: true)
                redirect_back fallback_location: root_path, notice: "Information saved"
                end
            end
        end
    end

    def user_history
        if params[:group].present?
            @group_payouts = GroupPayoutHistory.where(group_id: params[:group].to_i)
            @payouts = []
            @group_payouts.each do |t|
                @payouts.push(t.payouts)
            end
        else
            redirect_to :root
        end
    end

    def locale
        begin
            if params[:locale] == 'en'
            cookies.permanent[:locale] = 'en'
            elsif params[:locale] == 'ge'
            cookies.permanent[:locale] = 'ge'
            end
            redirect_to request.referer
        rescue
            redirect_to :root
        end
    end

private

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

end
