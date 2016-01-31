class WelcomeController < ApplicationController

  def index
    if user_signed_in?
      redirect_to landings_path
    else
      render :layout => 'navwelcome'
    end
  end
  
end
