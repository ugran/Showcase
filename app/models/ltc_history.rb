class LtcHistory < ApplicationRecord
    after_create_commit { ActionCable.server.broadcast "price_change", ltc_price: self.price }
end
