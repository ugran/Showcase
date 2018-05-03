class SlushpoolChannel < ApplicationCable::Channel
  def subscribed
    unless params[:user].present?
      if user_signed_in?
        stream_from "litecoinpool_#{current_user.id}"
      end
    else
      user = params[:user]
      stream_from "litecoinpool_#{user}"
    end
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
