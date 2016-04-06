class Message < ActiveRecord::Base
  belongs_to :user
  belongs_to :channel

include MessagesHelper

private

def message_params
  params.require(:message).permit(:slack_username, :ts, :slack_message, :id)
end
