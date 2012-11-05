class DashboardController < ApplicationController

  def show
    if current_user.leagues_belong_to.count.zero?
      redirect_to new_fantasy_league_path
    else
      @fantasy_leagues = current_user.leagues_belong_to


      # if leagues.count == 1
      #   league = leagues.first
      #   redirect_to fantasy_league_path(league)
      #   #team = league.current_week.current_team(league.participants.find_by_user(current_user))
      #   #redirect_to fantasy_league_fantasy_week_fantasy_team_path(league, league.current_week, team)
      # else

      # end
    end
  end

end