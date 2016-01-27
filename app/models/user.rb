class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:slack]

  has_many :messages

  def password_required?
    new_record? ? false : super
  end

  def email_required?
    false
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
    end
  #   binding.pry
  #   if !((User.find_by uid: auth.info["user_id"]) == nil)
  #     token_assign = User.find_by uid: auth.info["user_id"]
  #     token_assign.token = auth.credentials["token"]
  #     binding.pry
  #   else
  #     User.create!(uid: auth.info["user_id"], name: auth.info["user"],
  #     token: auth.credentials["token"])
  #   end
  #   binding.pry
  end

end
