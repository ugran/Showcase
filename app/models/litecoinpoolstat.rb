class Litecoinpoolstat < ApplicationRecord
    belongs_to :group
    after_save :broadcast

    def broadcast
        group = Group.find_by(id: self.group_id)
        if group.present?
            hash_allocation = []
            total_hash = 0
            group.users.each do |u|
                user_hash = {user: u.id}
                ltc_hash = 0
                u.miners.each do |m|
                    if m.algorithm == "Scrypt"
                        if m.prevhash > 0
                            ltc_hash = BigDecimal.new(ltc_hash.to_s) + BigDecimal.new(m.prevhash.to_s)
                        else
                            ltc_hash = BigDecimal.new(ltc_hash.to_s) + BigDecimal.new(m.accuhash.to_s)
                        end
                    end
                end
                total_hash = BigDecimal.new(total_hash.to_s) + BigDecimal.new(ltc_hash.to_s)
                user_hash[:ltc_hash] = ltc_hash
                hash_allocation.push(user_hash)
            end
            hash_allocation.each do |t|
                broadcast = {}
                broadcast[:user_total_hashrate] = (self.total_hashrate*t[:ltc_hash]/total_hash).round(4)
                broadcast[:user_total_rewards] = (self.total_rewards*t[:ltc_hash]/total_hash).round(4)
                broadcast[:user_paid_rewards] = (self.paid_rewards*t[:ltc_hash]/total_hash).round(4)
                broadcast[:user_unpaid_rewards] = (self.unpaid_rewards*t[:ltc_hash]/total_hash).round(4)
                broadcast[:user_expected_rewards] = (self.expected_rewards*t[:ltc_hash]/total_hash).round(4)
                broadcast[:user_past_24_rewards] = (self.past_24_rewards*t[:ltc_hash]/total_hash).round(4)
                broadcast[:user_cur_ltc] = User.find(t[:user]).cur_ltc
                if self.hashrate_distribution.present?
                    broadcast[:hashrate_distribution] = JSON.parse(self.hashrate_distribution).select{|k,v| User.find(t[:user]).miners.where(algorithm: 'Scrypt').map(&:worker_name).map {|s| s.gsub(' ', '')}.include? k.to_s}
                end
                ActionCable.server.broadcast "litecoinpool_#{t[:user]}", bcast: broadcast
            end
        end
    end

end
