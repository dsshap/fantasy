class FantasyParticipant

  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :fantasy_league

  field :user_id,       type: Moped::BSON::ObjectId
  field :team_name
  field :is_owner,      type: Boolean,                  default: false

  attr_accessible :user_id, :user, :is_owner, :team_name

  validates_presence_of :user_id

  state_machine :status, :initial => :pending do
    event :active do
      transition :pending => :active
    end
    event :complete do
      transition :active => :completed
    end
  end

  def total_league_points
    total_points = 0
    fantasy_league.weeks.each do |week|
      team = week.teams.find_by_participant(self)
      unless team.nil?
        total_points += team.get_weeks_total_points
      end
    end
    total_points.round(1)
  end

  def get_used_players(position)
    used_players = Array.new
    fantasy_league.weeks.each do |f_week|
      f_team = f_week.teams.find_by_participant(self)
      f_player = f_team.players.send(position)
      if f_player.is_a?(Array)
        f_player.each do |f_p|
          unless f_p.player.nil?
            used_players.push(f_p.player)
          end
        end
      else
        unless f_player.player.nil?
          used_players.push(f_player.player)
        end
      end
    end
    used_players
  end

  def get_current_team
    fantasy_league.current_week.current_team(self)
  end

  def user=(user)
    if user.class.name.eql?('User')
      self.user_id = user.id
    end
  end

  def user
    @user ||= User.find(user_id) rescue nil
  end

  def email_prefix
    if user.nil?
      email #.split('@')[0]
    else
      user.email #.split('@')[0]
    end
  end

end