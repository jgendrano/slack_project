class ChannelsController < ApplicationController
before_action :authenticate_user!
  def index
    if !(current_user.nil?)
      Channel.delete_all
      Channel.reset_pk_sequence
      create
    end
  end

  def create
    @channels = Channel.current_channels(current_user)
    @channels.each do |channel|
      Channel.create(channel_id: channel.channel_id,
      channel_name: channel.channel_name, purpose: channel.purpose)
    end
  end

  def show
    @channel = Channel.find(params[:id])
    @messages = Message.current_messages(current_user, @channel)
  end

private

def channel_params
  params.require(:channel).permit(
    :id,
    :channel_id,
    :channel_name,
    :purpose
  )
end

end
