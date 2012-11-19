class FantasyPlayer

  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :fantasy_team

  field :player_id,         type: Moped::BSON::ObjectId
  field :position

  attr_accessible :player_id, :player, :position

  def has_player?
    player_id ? true : false
  end

  def player=(player)
    if player.class.name.eql?('SportsPlayer')
      self.player_id = player.id
    end
  end

  def player
    @player ||= fantasy_team.fantasy_week.find_player(player_id) rescue nil
  end

  def fantasy_scores
    score_hash = Hash.new
    if has_player?
      fantasy_score_system = fantasy_team.fantasy_week.fantasy_league.scorings
      player.stats.each do |stat|
        score_system = fantasy_score_system.find_by_stat(stat.category, stat.sub_category)
        points = (stat.value / score_system.interval).floor * score_system.points
        score_hash[score_system.id] = points
      end
    end
    score_hash
  end

  def total
    score_hash = fantasy_scores
    score_hash.values.inject(0){|sum,x| sum+x}
  end


end