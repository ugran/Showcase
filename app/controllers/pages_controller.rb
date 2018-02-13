class PagesController < ApplicationController
    before_action :authenticate_admin, only: [:admin]
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

    def dashboard
        if user_signed_in?
            if current_user.active?
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
                unless current_user.group.present?
                    if current_user.nicehash?
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
                        miners_array.each do |a|
                            current_user.miners.each do |t|
                                miner_info = miners_array.select{ |m| (m[:wallet]+'.'+m[:worker]) == t.worker_name}
                                if miner_info.present?
                                    t.update(hashrate: miner_info.first[:hashrate], avg_hashrate: miner_info.first[:avg_hashrate], temperature: miner_info.first[:temperature] )
                                end
                            end
                        end
                        @miners = current_user.miners
                        @awesome = 1
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
                        current_user.update(nounce:nounce)
                        private_key = current_user.poloniex_secret
                        data = URI.encode_www_form({"command" => "returnBalances", "nonce" => nounce})
                        digest = OpenSSL::Digest.new('sha512')
                        signature = OpenSSL::HMAC.hexdigest(digest, private_key, data)
                        uri = URI.parse('https://poloniex.com/tradingApi')
                        https = Net::HTTP.new(uri.host,uri.port)
                        https.use_ssl = true
                        header = {"Sign": signature, "Key": current_user.poloniex_key, 
                        'Content-Type': 'application/x-www-form-urlencoded'}
                        req = https.post(uri.path, data, header)
                        @show = req.body
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
        elsif params[:start_scheduler].present?
            scheduler = Rufus::Scheduler.new
            job = scheduler.every '10s' do
                price_coin_usd = JSON.parse(URI.parse('https://min-api.cryptocompare.com/data/pricemulti?fsyms=BTC,ETH,XRP,LTC&tsyms=USD').read, :symbolize_names => true)
                BtcHistory.create(price: price_coin_usd[:BTC][:USD])
                EthHistory.create(price: price_coin_usd[:ETH][:USD])
                XrpHistory.create(price: price_coin_usd[:XRP][:USD])
                LtcHistory.create(price: price_coin_usd[:LTC][:USD])
            end
        elsif params[:products].present?
          @products = 1
          @products_all = Product.all
          @product = Product.new
        elsif product_params.present?
          @products = 1
          Product.create(product_params)
          @products_all = Product.all
          @product = Product.new
          redirect_back fallback_location: admin_path, notice: "Product created."
        elsif params[:edit_product].present?
          @edit_product = Product.find(params[:edit_product].to_i)
        elsif params[:edit_product_submit].present?
          Product.find_by(id: params[:edit_product_submit]).update(name: params[:edit_name], description: params[:edit_description], specifications: params[:edit_specifications])
        elsif params[:delete_product].present?
          Product.find(params[:delete_product].to_i).destroy
          redirect_back fallback_location: admin_path, notice: "Product deleted."
        else

        end
    end

private

    def group_params
        if params[:group].present?
            params.require(:group).permit(:name,:nicehash_wallet,:btc_wallet,:eth_wallet,:ltc_wallet,:api_key,:litecoinpool_api_key,:slushpool_api_key,:nicehash, :api_id, :id)
        end
    end

    def product_params
        if params[:product].present?
            params[:product].permit(:name, :description, :specifications, :category, :image)
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
