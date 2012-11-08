class FantasyTeamsController < ApplicationController

  def show
    @team = nil
    unless params[:fantasy_league_id].nil? 
      f_league = FantasyLeague.find(params[:fantasy_league_id]) rescue nil
      unless f_league.nil?
        unless params[:id].nil?
          f_league.weeks.each do |week|   #.find(params[:fantasy_week_id]).teams.find(params[:id]) rescue nil
            if week.teams.collect(&:id).include?(Moped::BSON::ObjectId(params[:id]))
              @team = week.teams.find(params[:id]) rescue nil
              break
            end
          end
        else
          redirect_to fantasy_league_path(f_league)
        end
      else
        redirect_to root_path
      end
    else
      redirect_to root_path
    end
    if @team.nil?
      redirect_to fantasy_league_path(f_league)        
    end

    @is_owner = @team.team_owner?(current_user)
  end

end