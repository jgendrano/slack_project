class MessagesController < ApplicationController
  def index
    @messages = Message.current_messages
  end

  def create

  end
end
