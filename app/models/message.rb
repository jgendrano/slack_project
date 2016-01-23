require 'dotenv-rails'

class Message
  attr_reader :slack_username, :ts, :slack_message, :id
  def initialize(slack_username, timestamp, slack_message, id)
    @slack_username = slack_username
    @ts = timestamp
    @slack_message = slack_message
    @id = id
  end

  def self.current_messages
    count = 1
    user_list = self.get_username_list
    raw_messages = self.get_messages_from_slack
    current_messages = raw_messages.map do |message|
      slack_username = user_list[message["user"]]
      slack_message = message["text"]
      timestamp = message["ts"]
      id = count
      count = count + 1
      new(slack_username, timestamp, slack_message, id)

    end
  end

  def self.get_messages_from_slack
    # URI will need to be updated
    uri = URI("https://slack.com/api/channels.history?token=#{ENV['SLACK_USER_TEST_TOKEN']}")
    binding.pry
    response = Net::HTTP.get_response(uri)

    messages = JSON.parse(response.body)['messages'].reverse
  end

  def self.get_username_list
    # URI will need to be updated
    # take URI as argument
    uri = URI("https://slack.com/api/users.list?token=#{ENV['SLACK_TEST_TOKEN']}")
    response = Net::HTTP.get_response(uri)
    users = JSON.parse(response.body)['members']

    user_list = Hash.new
    users.each do |user|
      user_list[user["id"]] = "#{user["real_name"]}"
    end
    user_list
  end
end

private

def message_params
  params.require(:message).permit(:slack_username, :ts, :slack_message, :id)
end
