class FantasyWeek

  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :fantasy_league

  field :week_number,           type: Integer

  embeds_many :teams, class_name: 'FantasyTeam', cascade_callbacks: true do
    def find_by_participant(participant)
      where(participant_id: participant.id).first
    end
    def find_all_by_participant(participant)
      where(participant_id: participant.id)
    end
  end

  attr_accessible :week_number
  accepts_nested_attributes_for :teams

  before_create :assign_week_number

  state_machine :status, :initial => :active do
    after_transition :on => :complete, :do => :increment_week_number
    event :complete do
      transition :active => :completed
    end
  end

  def name
    "Week: #{week_number}"
  end

  def teams_by_standing
    teams.sort_by{|t| -t.get_weeks_total_points}
  end

  def can_make_team?(participant)
    count = teams.where(participant_id: participant.id).count

    if count == 0 or count == 1 #can be one because its counting itself
      true
    else
      false
    end
  end

  def has_team?(participant)
    if teams.where(participant_id: participant.id).count.zero?
      false
    else
      true
    end
  end

  def current_team(participant)
    tmp_teams = teams.where(participant_id: participant.id)
    if tmp_teams.empty?
      nil
    else
      tmp_teams.first
    end
  end

  def assign_week_number
    self.week_number = fantasy_league.current_week_number
  end

  def increment_week_number
    fantasy_league.increment_current_week_number
  end

  def find_player(player_id)
    s_league = SportsLeague.get_sport(fantasy_league.sport)
    s_week = s_league.weeks.number(week_number)
    s_week.players.find(player_id)
  end

end