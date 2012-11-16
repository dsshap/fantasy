module FantasyPlayerHelper

  def player_action(f_player)
    msg = nil
    unless f_player.player.nil?
      msg = f_player.player.name
      msg << link_to("Change", fantasy_league_sports_players_path(params[:fantasy_league_id], position: f_player.position))
      msg << link_to("Drop", fantasy_league_fantasy_team_drop_player_path(f_player.fantasy_team.fantasy_week.fantasy_league, f_player.fantasy_team, f_player))
    else
      if @is_owner
        msg = link_to "Add", fantasy_league_sports_players_path(params[:fantasy_league_id], position: f_player.position)
      else
        msg = "--"
      end
    end
    msg.html_safe
  end

  def player_stat(player_stat)
    unless player_stat.nil?
      player_stat.value
    end
  end

end

