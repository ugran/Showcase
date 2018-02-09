class EthHistory < ApplicationRecord
    after_create_commit { ActionCable.server.broadcast "price_change", eth_price: self.price }
end
