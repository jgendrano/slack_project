class Message < ActiveRecord::Base
  belongs_to :user
  belongs_to :channel

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
      slack_message = message["text"]
      raw_slack_message = message["text"]
      timestamp = DateTime.strptime(message["ts"], '%s')
      # self.message_parse(raw_slack_message)
      id = count
      count = count + 1
      new(slack_username: slack_username, ts: timestamp, slack_message:
      slack_message, id: id, user_id: current_user.id)
    end
  end

  def self.messsage_parse(raw_slack_message)
    if raw_slack_message[/\<.*?\>/]
      mod_user = raw_slack_message[/\@.*?\|/]
      x = mod_user.split("")
      x.shift
      x.pop
      slack_message = raw_slack_message.sub(raw_slack_message[/\<.*?\>/], user_list[x.join("")])
    end
    # if raw_slack_message[/\<@.*?\>/].length == 12
    #   x = raw_slack_message
    #   x.slice!(0..1)
    #   x.slice!(-1)
    #   slack_message = raw_slack_message.sub(raw_slack_message[/\<@.*?\>/], user_list[x])
    # end
    return slack_message
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

private

def message_params
  params.require(:message).permit(:slack_username, :ts, :slack_message, :id)
end
