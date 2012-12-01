class DashboardController < ApplicationController

  def show
    unless current_user.pending_invitations.count.zero?
      @fantasy_league_invitations = current_user.pending_invitations
      @fantasy_leagues = current_user.leagues_belong_to
    else
      if current_user.leagues_belong_to.count.zero?
        redirect_to new_fantasy_league_path
      else
        @fantasy_leagues = current_user.leagues_belong_to
      end
    end
  end

end