class LitecoinpoolChannel < ApplicationCable::Channel
  def subscribed
    stream_from "litecoinpool_#{current_user.id}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
