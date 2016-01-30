class Message
  attr_reader :slack_username, :ts, :slack_message, :id
  def initialize(slack_username, timestamp, slack_message, id)
    @slack_username = slack_username
    @ts = timestamp
    @slack_message = slack_message
    @id = id
  end

  def self.current_messages(current_user, channel)
    count = 1
    user_list = self.get_username_list(current_user.token)
    raw_messages = self.get_messages_from_slack(current_user, channel)
    current_messages = raw_messages.map do |message|
      slack_username = user_list[message["user"]]
      slack_message = message["text"]
      timestamp = message["ts"]
      id = count
      count = count + 1
      new(slack_username, timestamp, slack_message, id)
    end
  end

  def self.get_messages_from_slack(current_user, channel)
    uri = URI("https://slack.com/api/channels.history?token=#{current_user.token}&channel=#{channel.channel_id}")
    response = Net::HTTP.get_response(uri)
    messages = JSON.parse(response.body)['messages'].reverse
    return messages
  end

  def self.get_username_list(token)
    uri = URI("https://slack.com/api/users.list?token=#{token}")
    response = Net::HTTP.get_response(uri)
    users = JSON.parse(response.body)['members']
    user_list = Hash.new
    users.each do |user|
      if user["real_name"] == ''
        user_list[user["id"]] = "@#{user["name"]}"
      else
        user_list[user["id"]] = "@#{user["name"]} (#{user["real_name"]})"
      end
    end
    user_list
  end
end

private

def message_params
  params.require(:message).permit(:slack_username, :ts, :slack_message, :id)
end
