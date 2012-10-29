class FantasyPlayer

  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :fantasy_team

  field :player_id,         type: Moped::BSON::ObjectId
  field :position

  attr_accessible :player_id, :player, :position

  def player=(player)
    if player.class.name.eql?('SportsPlayer')
      self.player_id = player.id
    end
  end

  def player
    @player ||= fantasy_team.fantasy_week.find_player(player_id) rescue nil
  end

end