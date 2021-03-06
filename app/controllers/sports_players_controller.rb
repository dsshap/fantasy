class SportsPlayersController < ApplicationController

  def index
    @fantasy_league = FantasyLeague.find(params[:fantasy_league_id]) rescue nil

    unless @fantasy_league.nil?

      current_user_participant = @fantasy_league.participants.find_by_user(current_user)

      unless current_user_participant.nil?

        unless params[:position].nil? or !(%w[qb rb wr_te wr te].include?(params[:position]))
          @used_players = current_user_participant.get_used_players(params[:position])
          @current_f_player = current_user_participant.get_current_team.players.find_by_choice(params[:position], params[:f_player_id])
          sports_league = SportsLeague.where(name: "football").first
          current_sports_week = sports_league.current_week
          @all_players = current_sports_week.send(params[:position])
          @available_players = Array.new

          used_player_names = @used_players.collect(&:name)
          @all_players.each do |player|
            unless used_player_names.include?(player.name)
              @available_players.push(player)
            end
          end
        else
          flash[:error] = "That position isn't one we are allowing you to have in this fantasy game..."
          redirect_to fantasy_league_fantasy_team_path(@fantasy_league, @fantasy_league.current_week.current_team(current_user_participant))
        end

      else
        flash[:error] = "You are not a participant in this league..."
        redirect_to root_path
      end

    else
      flash[:error] = "That fantasy league does not exist..."
      redirect_to root_path
    end

  end

end