class PinsController < ApplicationController
  before_action :authenticate_user!

  def index
    get_team_info
    @pins = Pin.where(user_id: current_user.id)
  end

  def new
    @message = Message.find(params["format"])
    @pin = Pin.new
     binding.pry
  end

  def create
    # message = Message.find(params["format"])
    # @message = Message.find(params["format"])
    # pin_params[:id] = @message.id
    # pin_params[:user_id] = @message.user_id
    # pin_params[:slack_username]= @message.slack_username
    # pin_params[:slack_message] = @message.slack_message
    # pin_params[:ts] = @message.ts
    binding.pry
    @pin = Pin.create(pin_params)
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
      :slack_username,
      :slack_message,
      :ts
    )
  end
end
