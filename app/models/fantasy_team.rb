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
      where(position: 'wr/te')
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
    players.create position: 'wr/te'
    players.create position: 'wr/te'
  end

  def name
    'team: ' + participant.user.email
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

  def participant=(participant)
    if participant.class.name.eql?('FantasyParticipant')
      self.participant_id = participant.user.id
    end
  end

  def participant
    @participant ||= fantasy_week.fantasy_league.participants.where(user_id: participant_id).first rescue nil
  end


end