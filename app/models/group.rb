class Group < ApplicationRecord
    has_many :users
    has_many :group_payout_history
    has_one :litecoinpoolstat
    has_one :slushpoolstat
end
