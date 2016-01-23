class PinsController < ApplicationController
  def index
    @pins = Pin.all
  end

  def create
    @pin = Pin.new(params["data"]["user"], params["data"]["text"], params["data"]["ts"])
    binding.pry
    redirect_to pins_path
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
