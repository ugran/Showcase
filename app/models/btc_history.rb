class BtcHistory < ApplicationRecord
    after_create_commit { ActionCable.server.broadcast "price_change", btc_price: self.price }
end
