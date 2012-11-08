module FantasyPlayerHelper

  def player_name(f_player)
    msg = nil
    unless f_player.player.nil?
      msg = link_to f_player.player.name, nil
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

