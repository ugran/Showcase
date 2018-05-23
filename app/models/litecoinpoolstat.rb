class Litecoinpoolstat < ApplicationRecord
    belongs_to :group
    after_save :broadcast

    def broadcast
        group = Group.find_by(id: self.group_id)
        if group.present?
            hash_allocation = []
            total_hash = 0
            user_miners = []
            group.users.each do |u|
                total_ltc_hashrate = 0
                user_hash = {user: u.id}
                ltc_hash = 0
                u.miners.each do |m|
                    if m.algorithm == "Scrypt"
                        if m.prevhash > 0
                            ltc_hash = BigDecimal.new(ltc_hash.to_s) + BigDecimal.new(m.prevhash.to_s)
                        else
                            ltc_hash = BigDecimal.new(ltc_hash.to_s) + BigDecimal.new(m.accuhash.to_s)
                        end
                        user_miners.push({worker_name: m.worker_name, hashrate: m.hashrate, avg_hashrate: m.avg_hashrate, temperature: m.temperature})
                        total_ltc_hashrate = (BigDecimal.new(total_ltc_hashrate.to_s)+BigDecimal.new(m.hashrate.to_f.to_s)).to_s.to_f
                    end
                end
                total_hash = BigDecimal.new(total_hash.to_s) + BigDecimal.new(ltc_hash.to_s)
                user_hash[:ltc_hash] = ltc_hash
                user_hash[:total_ltc_hashrate] = total_ltc_hashrate
                user_hash[:user_miners] = user_miners
                if u.percent_fee.present?
                    user_hash[:percent_fee] = u.percent_fee.to_i/100
                else
                    user_hash[:percent_fee] = 0
                end
                hash_allocation.push(user_hash)
            end
            hash_allocation.each do |t|
                broadcast = {}
                broadcast[:user_total_ltc_hashrate] = t[:total_ltc_hashrate]
                broadcast[:user_total_rewards] = (BigDecimal.new((self.total_rewards*t[:ltc_hash]/total_hash).to_s)-BigDecimal.new((self.total_rewards*t[:ltc_hash]/total_hash*t[:percent_fee]).to_s)).to_s.to_f.round(4)
                broadcast[:user_paid_rewards] = (BigDecimal.new((self.paid_rewards*t[:ltc_hash]/total_hash).to_s)-BigDecimal.new((self.paid_rewards*t[:ltc_hash]/total_hash*t[:percent_fee]).to_s)).to_s.to_f.round(4)
                broadcast[:user_unpaid_rewards] = (BigDecimal.new((self.unpaid_rewards*t[:ltc_hash]/total_hash).to_s)-BigDecimal.new((self.unpaid_rewards*t[:ltc_hash]/total_hash*t[:percent_fee]).to_s)).to_s.to_f.round(4)
                broadcast[:user_expected_rewards] = (BigDecimal.new((self.expected_rewards*t[:ltc_hash]/total_hash).to_s)-BigDecimal.new((self.expected_rewards*t[:ltc_hash]/total_hash*t[:percent_fee]).to_s)).to_s.to_f.round(4)
                broadcast[:user_past_24_rewards] = (BigDecimal.new((self.past_24_rewards*t[:ltc_hash]/total_hash).to_s)-BigDecimal.new((self.past_24_rewards*t[:ltc_hash]/total_hash*t[:percent_fee]).to_s)).to_s.to_f.round(4)
                if User.find(t[:user]).user_balance.present?
                    broadcast[:user_cur_ltc] = User.find(t[:user]).user_balance.cur_ltc
                end
                broadcast[:user_miners] = t[:user_miners]
                if self.hashrate_distribution.present?
                    broadcast[:hashrate_distribution] = JSON.parse(self.hashrate_distribution).select{|k,v| User.find(t[:user]).miners.where(algorithm: 'Scrypt').map(&:worker_name).map {|s| s.gsub(' ', '')}.include? k.to_s}
                end
                ActionCable.server.broadcast "litecoinpool_#{t[:user]}", bcast: broadcast
            end
        end
    end

end
