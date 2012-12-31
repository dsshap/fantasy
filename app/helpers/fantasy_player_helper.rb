module FantasyPlayerHelper

  def player_action(f_player)
    msg = nil

    unless f_player.player.nil?
      if f_player.player.eligible? and !@is_owner
        msg = @player_masks.delete_at(0)
      else
        msg = f_player.player.name
      end

      if f_player.player.eligible? and @is_owner
        links = link_to("Change", fantasy_league_sports_players_path(params[:fantasy_league_id], position: f_player.position, f_player_id: f_player), class: 'btn btn-mini')
        links << "&nbsp;".html_safe
        links << link_to("Drop", fantasy_league_fantasy_team_drop_player_path(f_player.fantasy_team.fantasy_week.fantasy_league, f_player.fantasy_team, f_player), class: 'btn btn-mini btn-danger')
        msg << content_tag(:div, links, class: 'pull-right')
      end
    else
      if @is_owner
        link = link_to "Add Player", fantasy_league_sports_players_path(params[:fantasy_league_id], position: f_player.position, f_player_id: f_player), class: 'btn btn-primary'
        msg = content_tag(:div, link, class: 'pull-right')
      else
        msg = "--"
      end
    end
    msg.html_safe
  end

  def playing_team(f_player)
    if f_player.player.eligible? and !@is_owner
      @team_masks.delete_at(0)
    else
      f_player.player.opponent
    end
  end

  def player_stat(player_stat)
    unless player_stat.nil?
      player_stat.value.round(1)
    end
  end

end

