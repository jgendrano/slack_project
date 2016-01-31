class MessagesController < ApplicationController
  before_action :authenticate_user!

private

def message_params
  params.require(:message).permit(:slack_username, :ts, :slack_message, :id)
end

end
