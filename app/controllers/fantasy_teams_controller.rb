class FantasyTeamsController < ApplicationController

  def show
    @team = nil
    unless params[:fantasy_league_id].nil? 
      f_league = FantasyLeague.find(params[:fantasy_league_id]) rescue nil
      unless f_league.nil?
        unless params[:id].nil?

          team_id = Moped::BSON::ObjectId(params[:id]) rescue nil

          unless team_id.nil?
            f_league.weeks.each do |week|   #.find(params[:fantasy_week_id]).teams.find(params[:id]) rescue nil
              if week.teams.collect(&:id).include?(team_id)
                @team = week.teams.find(params[:id]) rescue nil
                break
              end
            end

            if @team.nil?
              redirect_to fantasy_league_path(f_league)        
            else
              @is_owner = @team.team_owner?(current_user)

              Evently.record(current_user, 'viewed', @team)

            end

          else
            redirect_to fantasy_league_path(f_league)
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

  end

  def drop_player
    unless params[:fantasy_league_id].nil? 
      f_league = FantasyLeague.find(params[:fantasy_league_id]) rescue nil
      unless f_league.nil?
        unless params[:fantasy_team_id].nil?

          f_team_id = Moped::BSON::ObjectId(params[:fantasy_team_id]) rescue nil
          unless f_team_id.nil?
            f_league.weeks.each do |week|   #.find(params[:fantasy_week_id]).teams.find(params[:id]) rescue nil
              if week.teams.collect(&:id).include?(f_team_id)
                f_team = week.teams.find(f_team_id) rescue nil

                unless params[:f_player_id].nil?
                  f_player = f_team.players.find(params[:f_player_id]) rescue nil

                  unless f_player.nil?
                    s_player = f_player.player
                    f_player.player_id = nil
                    f_player.save

                    Evently.record(current_user, "dropped", s_player, "from", f_team)

                    flash[:success] = "Successfully dropped #{s_player.name}"
                    redirect_to fantasy_league_fantasy_team_path(f_league, f_team)

                  else
                    flash[:error] = "Fantasy player does not exist"
                    redirect_to fantasy_league_fantasy_team_path(f_league, f_team)
                  end

                else
                  redirect_to fantasy_league_fantasy_team_path(f_league, f_team)
                end
  
              else
                redirect_to fantasy_league_path(f_league)
              end
            end

          else
            redirect_to fantasy_league_path(f_league)
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
  end

end