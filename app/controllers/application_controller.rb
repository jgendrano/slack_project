class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def after_sign_in_path_for(resource)
    session_return_to = session[:return_to]
    session[:return_to] = nil
    stored_location_for(resource) || session_return_to || channels_path
  end

  def after_sign_out_path_for(resource_or_scope)
    root_path
  end

  def after_sign_in_path_for(resource)
    # request.env['omniauth.origin'] || stored_location_for(resource) || landings_path
    landings_path
  end

  def get_team_info
    uri=URI("https://slack.com/api/team.info?token=#{current_user.token}&pretty=1")
    response = Net::HTTP.get_response(uri)
    team = JSON.parse(response.body)
    @team_name = team["team"]["name"]
    @team_domain = team["team"]["domain"]
    @team_pic = team["team"]["icon"]["image_132"]
  end



end
