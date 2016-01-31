class LandingsController < ApplicationController
  before_action :authenticate_user!
  def index
    get_team_info
  end
end
