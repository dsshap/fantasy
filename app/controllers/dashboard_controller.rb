class DashboardController < ApplicationController

  def show
    if current_user.leagues_belong_to.count.zero?
      redirect_to new_fantasy_league_path
    else

    end
  end

end