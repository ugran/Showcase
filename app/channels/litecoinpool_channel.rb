class LitecoinpoolChannel < ApplicationCable::Channel
  def subscribed
    unless params[:user].present?
      stream_from "litecoinpool_#{current_user.id}"
    else
      user = params[:user]
      if user.present?
        stream_from "litecoinpool_#{user}"
      end
    end
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
