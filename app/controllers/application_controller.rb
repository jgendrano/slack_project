class ApplicationController < ActionController::Base
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
    landings_path
  end
end
