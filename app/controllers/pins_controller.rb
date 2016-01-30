class PinsController < ApplicationController
  def index
    @pins = Pin.all
  end

  def create
    pin = params["data"]
    @pin = Pin.create(user_id: current_user.id, slack_username: pin["user"],
    ts: pin["ts"], slack_message: pin["text"])
    if @pin.save
      flash[:success] = "Book added successfully!"
      redirect_to pins_path
    else
      flash[:warning] = @pin.errors.full_messages.join(', ')
      redirect_to channel_path(channel.id)
    end
  end

private

  def pin_params
    params.require(:pin).permit(
      :user,
      :text,
      :ts
    )
  end
end
