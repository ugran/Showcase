class Group < ApplicationRecord
    has_many :users
    has_one :litecoinpoolstat
    has_one :slushpoolstat
end
