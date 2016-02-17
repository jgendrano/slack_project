class Message < ActiveRecord::Base
  belongs_to :user
  belongs_to :channel

private

  def self.current_messages(current_user, channel)
    count = 1
    user_list = self.get_username_list(current_user.token)
    raw_messages = self.get_messages_from_slack(current_user, channel)
    current_messages = raw_messages.map do |message|
      if message["user"].nil?
        slack_username = message["username"]
      else
        slack_username = user_list[message["user"]]
      end

      raw_slack_message = message["text"]

      while (raw_slack_message.include? "<mailto:") do
        x = raw_slack_message[/\<mailto.*?\>/]
        x.slice!(0..7)
        slack_message = raw_slack_message.sub!(raw_slack_message[/\<mailto.*?\>/], x.split("|")[0])
      end

      while !(raw_slack_message[/\<.*?\>/].nil?) && (raw_slack_message[/\<.*?\>/].length == 12) do
        mod_user = raw_slack_message[/\<.*?\>/]
        mod_user.slice!(0..1)
        mod_user.slice!(-1)
        slack_message = raw_slack_message.sub!(raw_slack_message[/\<.*?\>/], user_list[mod_user])
      end

      if !(raw_slack_message[/\<.*?\>/].nil?) && !(raw_slack_message.include? "http") && !(raw_slack_message.include? "<!")
        mod_user = raw_slack_message[/\@.*?\|/]
        x = mod_user.split("")
        x.shift
        x.pop
        slack_message = raw_slack_message.sub(raw_slack_message[/\<.*?\>/], user_list[x.join("")])
      elsif !(raw_slack_message[/\<.*?\|/].nil?) && (raw_slack_message.include? "http")
        mod_user = raw_slack_message[/\@.*?\|/]
        mod_user.slice!(0)
        mod_user.slice!(-1)
        slack_message = raw_slack_message.sub!(raw_slack_message[/\<.*?\>/], user_list[mod_user])
      else
        slack_message = raw_slack_message
      end

      timestamp = DateTime.strptime(message["ts"], '%s')
      id = count
      count = count + 1
      new(slack_username: slack_username, ts: timestamp, slack_message:
      slack_message, id: id, user_id: current_user.id)
    end
    return current_messages
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
      # if user["real_name"] == '' && user["name"] == ''
      #   ser_list[user["id"]] = "@#{user["username"]}"
      if user["real_name"] == ''
        user_list[user["id"]] = "@#{user["name"]}"
      else
        user_list[user["id"]] = "@#{user["name"]} (#{user["real_name"]})"
      end
    end
    user_list
  end
end


def message_params
  params.require(:message).permit(:slack_username, :ts, :slack_message, :id)
end
