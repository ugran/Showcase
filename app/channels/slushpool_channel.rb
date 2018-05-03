class SlushpoolChannel < ApplicationCable::Channel
  def subscribed
    unless params[:user].present?
      stream_from "slushpool_#{current_user.id}"
    else
      user = params[:user]
      stream_from "slushpool_#{user}"
    end
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
