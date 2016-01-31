class PinsController < ApplicationController
  before_action :authenticate_user!

  def index
    get_team_info
    @pins = Pin.where(user_id: current_user.id)
  end

  def create
    pin = params["data"]
    @pin = Pin.create(user_id: current_user.id, slack_username: pin["user"],
    ts: pin["ts"], slack_message: pin["text"])
    if @pin.save
      flash[:success] = "Pin added successfully!"
      redirect_to pins_path
    else
      flash[:warning] = @pin.errors.full_messages.join(', ')
      redirect_to channel_path(channel.id)
    end
  end

  def destroy
    @pin = Pin.find(params[:id])
    @pin.destroy
    redirect_to pins_path
  end

private

  def pin_params
    params.require(:pin).permit(
      :id,
      :user_id,
      :user,
      :text,
      :ts
    )
  end
end
