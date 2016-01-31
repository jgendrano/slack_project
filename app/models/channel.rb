class Channel < ActiveRecord::Base
  belongs_to :user
  has_many :messages

  def self.current_channels(current_user)
    count = 1
    raw_channels = get_channels_from_slack(current_user.token)
    current_channel = raw_channels.map do |channel|
      channel_id = channel["id"]
      channel_name = channel["name"]
      purpose = channel["purpose"]["value"]
      id = count
      count = count + 1
      new(id: id, channel_id: channel_id, channel_name: channel_name, purpose: purpose)
    end
  end

  def self.get_channels_from_slack(token)
    uri = URI("https://slack.com/api/channels.list?token=#{token}&pretty=1")
    response = Net::HTTP.get_response(uri)
    channels = JSON.parse(response.body)["channels"]
  end

  private

  def channel_params
    params.require(:message).permit(:channel_id, :channel_name, :purpose)
  end
end
