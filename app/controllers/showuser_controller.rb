class ShowuserController < ApplicationController
    require 'net/http'
    require "open-uri"
    require "uri"

    def show_user
        if current_user.admin?
            @user = User.find(params[:show_user])
            if @user.active?
                if @user.group_id.blank? || @user.group_id == 0
                    if @user.nicehash?
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
                        @miners = @user.miners
                        @nicehash_current = JSON.parse(URI.parse('https://api.nicehash.com/api?method=stats.provider&addr='+@user.nicehash_wallet).read, :symbolize_names => true)
                        @profitability = JSON.parse(URI.parse('https://api.nicehash.com/api?method=stats.global.24h').read, :symbolize_names => true)
                        @btc_price = JSON.parse(URI.parse('https://api.coindesk.com/v1/bpi/currentprice.json').read, :symbolize_names => true)[:bpi][:USD][:rate_float]
                        @balance = JSON.parse(URI.parse('https://api.nicehash.com/api?method=balance&id='+@user.api_id+'&key='+@user.api_key).read, :symbolize_names => true)
                        @key = @user.api_key
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
                            @user.miners.each do |t|
                                miner_info = miners_array.select{ |m| m[:worker] == t.worker_name}
                                if miner_info.present?
                                    t.update(hashrate: miner_info.first[:hashrate], avg_hashrate: miner_info.first[:avg_hashrate], temperature: miner_info.first[:temperature] )
                                end
                            end
                        end
                        @miners = @user.miners
                        ltc_api = @user.litecoinpool_api_key
                        slush_api = @user.slushpool_api_key
                        if @user.litecoinpool_api_key.present?
                            @ltc = JSON.parse(URI.parse('https://www.litecoinpool.org/api?api_key='+ltc_api).read, :symbolize_names => true)
                        end
                        if @user.slushpool_api_key.present?
                            @btc = JSON.parse(URI.parse('https://slushpool.com/accounts/profile/json/'+slush_api).read, :symbolize_names => true)
                        end
                        if @user.nounce.present?
                            nounce = @user.nounce+1
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
                    @group = @user.group
                    if @group.litecoinpool_api_key.present? && Miner.where(user_id: @user.id, algorithm: 'Scrypt').present?
                        @ltc = 1
                    end
                    if @group.slushpool_api_key.present? && Miner.where(user_id: @user.id, algorithm: 'SHA256').present?
                        @btc = 1
                    end
                    @miners = @user.miners
                end
            end
        end
    end

end