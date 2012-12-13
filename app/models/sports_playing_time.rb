class SportsPlayingTime

  include Mongoid::Document

  field :playing_time,      type: DateTime

  just_define_datetime_picker :playing_time, :add_to_attr_accessible => true

  def set_players_to_active
    s_league = SportsLeague.where(name: "football").first

    s_league.current_week.eligable_players.each do |player|
      if player.sports_playing_time_id == id.to_s
        player.in_play
        player.save
      end
    end
  end

  def set_players_to_done
    s_league = SportsLeague.where(name: "football").first
    s_league.current_week.in_play_players.where(sports_playing_time_id: id.to_s).each do |player|
      player.done
      player.save
    end
  end

end