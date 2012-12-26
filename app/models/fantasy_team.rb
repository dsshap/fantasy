class FantasyTeam

  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :fantasy_week

  field :participant_id,        type: Moped::BSON::ObjectId

  embeds_many :players, class_name: 'FantasyPlayer', cascade_callbacks: true do
    def qb
      where(position: 'qb').first
    end

    def rb
      where(position: 'rb').first
    end

    def wr_te
      where(position: 'wr_te').to_a
    end

    def wr
      where(position: 'wr')
    end

    def te
      where(position: 'te').first
    end

    def find_by_choice(position, f_player_id)
      where(position: position, id: f_player_id).first
    end
  end

  attr_accessible :participant_id, :participant
  accepts_nested_attributes_for :players

  validates_presence_of :participant_id
  validate :participant_part_of_league
  validate :participant_can_only_make_one_team_per_week

  after_create :set_up_players

  state_machine :status, :initial => :active do
    event :complete do
      transition :active => :completed
    end
  end

  def set_up_players
    players.create position: 'qb'
    players.create position: 'rb'
    if fantasy_week.fantasy_league.hardcore
      players.create position: 'te'
      players.create position: 'wr'
      players.create position: 'wr'
    else
      players.create position: 'wr_te'
      players.create position: 'wr_te'
    end


  end

  def name
    'team: ' + participant.user.email
  end

  def get_weeks_total_points
    players.collect(&:total).inject(0){|sum,x| sum+x}
  end

  def participant_can_only_make_one_team_per_week
    unless fantasy_week.can_make_team?(participant)
      errors.add(:participant, 'user already has a team for this week')
    end
  end

  def participant_part_of_league
    unless fantasy_week.fantasy_league.is_participant?(participant)
      errors.add(:participant, 'user not part of league')
    end
  end

  def team_owner?(user)
    participant.user.id.eql?(user.id)
  end

  def participant=(participant)
    if participant.class.name.eql?('FantasyParticipant')
      self.participant_id = participant.id
    end
  end

  def participant
    @participant ||= fantasy_week.fantasy_league.participants.find(participant_id) rescue nil
  end


end