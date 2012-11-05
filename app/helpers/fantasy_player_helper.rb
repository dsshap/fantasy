module FantasyPlayerHelper

  def player_name(player)
    msg = nil
    unless player.nil?
      msg = link_to player.name, nil
    else
      msg = link_to "Add", nil
    end
    msg.html_safe
  end

end

