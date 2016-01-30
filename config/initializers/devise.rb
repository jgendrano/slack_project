Devise.setup do |config|
  #Replace example.com with your own domain name
  config.mailer_sender = 'mailer@example.com'

  require 'devise/orm/active_record'
  config.warden do |manager|
    manager.failure_app = CustomFailure
  end
  config.case_insensitive_keys = [ :email ]
  config.strip_whitespace_keys = [ :email ]
  config.skip_session_storage = [:http_auth]
  config.stretches = Rails.env.test? ? 1 : 10
  config.reconfirmable = true
  config.expire_all_remember_me_on_sign_out = true
  config.password_length = 8..128
  config.reset_password_within = 6.hours
  config.sign_out_via = :delete


  #Add your ID and secret here
  #ID first, secret second
  config.omniauth :slack, ENV['SLACK_APP_ID'], ENV['SLACK_APP_SECRET'],
  scope: 'channels:read, channels:history, chat:write:user, users:read'


end
