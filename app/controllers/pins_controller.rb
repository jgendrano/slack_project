class PinsController < ApplicationController
  before_action :authenticate_user!

  def index
    get_team_info
    @pins = Pin.where(user_id: current_user.id)
  end

  def create
    message = Message.find(params["format"])
    @pin = Pin.create(user_id: current_user.id, slack_username: message["slack_username"],
    ts: message["ts"], slack_message: message["slack_message"])
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
