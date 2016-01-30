class MessagesController < ApplicationController
  before_action :authenticate_user!
  # def index
  #   @messages = Message.current_messages
  # end
  #
  # def destroy
  # end
end
