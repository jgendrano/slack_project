class ChannelsController < ApplicationController
before_action :authenticate_user!
  def index
    if !(current_user.nil?)
      Channel.delete_all
      Channel.reset_pk_sequence
      get_team_info
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
    get_team_info
    @channel = Channel.find(params[:id])
    Message.delete_all
    Message.reset_pk_sequence
    @messages = Message.current_messages(current_user, @channel)
    @messages.each do |message|
      Message.create(slack_username: message.slack_username,
      ts: message.ts, slack_message: message.slack_message,
      user_id: current_user.id)
    end
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
