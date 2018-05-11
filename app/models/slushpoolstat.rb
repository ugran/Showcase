class Slushpoolstat < ApplicationRecord
    belongs_to :group
    after_save :broadcast
    
    def broadcast
        group = Group.find_by(id: self.group_id)
        if group.present?
            hash_allocation = []
            total_hash = 0
            group.users.each do |u|
                user_hash = {user: u.id}
                btc_hash = 0
                user_miners = []
                total_btc_hashrate = 0
                u.miners.each do |m|
                    if m.algorithm == "SHA256"
                        if m.prevhash > 0
                            btc_hash = BigDecimal.new(btc_hash.to_s) + BigDecimal.new(m.prevhash.to_s)
                        else
                            btc_hash = BigDecimal.new(btc_hash.to_s) + BigDecimal.new(m.accuhash.to_s)
                        end
                        user_miners.push({worker_name: m.worker_name, hashrate: m.hashrate, avg_hashrate: m.avg_hashrate, temperature: m.temperature})
                        total_btc_hashrate = (BigDecimal.new(total_btc_hashrate.to_s)+BigDecimal.new(m.hashrate.to_f.to_s)).to_f
                    end
                end
                total_hash = BigDecimal.new(total_hash.to_s) + BigDecimal.new(btc_hash.to_s)
                user_hash[:btc_hash] = btc_hash
                user_hash[:total_btc_hashrate] = total_btc_hashrate
                user_hash[:user_miners] = user_miners
                hash_allocation.push(user_hash)
            end
            hash_allocation.each do |t|
                broadcast = {}
                broadcast[:user_total_hashrate] = t[:total_btc_hashrate]
                broadcast[:user_confirmed_reward] = (self.confirmed_reward*t[:btc_hash]/total_hash).round(4)
                broadcast[:user_unconfirmed_reward] = (self.unconfirmed_reward*t[:btc_hash]/total_hash).round(4)
                broadcast[:user_estimated_reward] = (self.estimated_reward*t[:btc_hash]/total_hash).round(4)
                broadcast[:user_cur_btc] = User.find(t[:user]).user_balance.cur_btc
                broadcast[:user_miners] = t[:user_miners]
                if self.hashrate_distribution.present?
                    broadcast[:hashrate_distribution] = JSON.parse(self.hashrate_distribution).select{|k,v| User.find(t[:user]).miners.where(algorithm: 'SHA256').map(&:worker_name).map {|s| s.gsub(' ', '')}.include? k.to_s}
                end
                ActionCable.server.broadcast "slushpool_#{t[:user]}", bcast: broadcast
            end
        end
    end

end
