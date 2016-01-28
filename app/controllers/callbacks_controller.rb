class CallbacksController < Devise::OmniauthCallbacksController
  def slack
    @user = User.from_omniauth(request.env["omniauth.auth"])
    @user.token = request.env["omniauth.auth"]["credentials"]["token"]
    @user.name = request.env["omniauth.auth"]["info"]["user"]
    sign_in_and_redirect @user
  end

  def failure
    redirect_to root_path
  end
end
