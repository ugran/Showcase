class PriceChartChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'price_change'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

end
