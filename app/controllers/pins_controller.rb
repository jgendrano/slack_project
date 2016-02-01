class PinsController < ApplicationController
  before_action :authenticate_user!

  def index
    get_team_info
    @pins = Pin.where(user_id: current_user.id)
  end

  def new
    get_team_info
    @message = Message.find(params["format"])
    @pin = Pin.new
  end

  def create
    @pin = Pin.create(pin_params)
    if @pin.save
      flash[:notice] = "Pin added successfully!"
      redirect_to pins_path
    else
      flash[:errors] = @pin.errors.full_messages.join(', ')
      render :new
    end
  end

  def show
    get_team_info
    @pin = Pin.find(params[:id])
  end

  def edit
    get_team_info
    @pin = Pin.find(params[:id])
  end

  def update
    @pin = Pin.find(params[:id])
    @pin.update(pin_params)
    if @pin.update(pin_params)
      flash[:success] = "Pinned message updated successfully!"
      redirect_to pins_path
    else
      create_or_update_failure
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
      :ts,
      :title,
      :note
    )
  end
end

def create_or_update_failure
  flash[:warning] = @review.errors.full_messages.join(', ')
  render :new
end
