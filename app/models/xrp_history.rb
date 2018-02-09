class XrpHistory < ApplicationRecord
    after_create_commit { ActionCable.server.broadcast "price_change", xrp_price: self.price }
end
