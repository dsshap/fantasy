class FantasyLeague

  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user

  field :name
  field :current_week_number,      type: Integer, default: 1
  field :sport,                    default: 'football'

  embeds_many :scorings, class_name: 'FantasyScoring', cascade_callbacks: true  do
    def find_by_stat(category, sub_category)
      where(category: category, sub_category: sub_category).first
    end
  end

  embeds_many :weeks, class_name: 'FantasyWeek', cascade_callbacks: true
  embeds_many :participants, class_name: 'FantasyParticipant', cascade_callbacks: true do
    def find_by_user(user)
      where(status: :active, user_id: user.id).first
    end
  end

  has_many :invitations, class_name: 'FantasyInvitation'
  has_one :message_board

  attr_accessible :name, :current_week_number, :scorings_attributes, :invitations_attributes, :message_board_attributes
  accepts_nested_attributes_for :weeks, :participants, :scorings, :invitations, :message_board, :allow_destroy => true

  validates_presence_of :name

  after_create :add_owner_as_participant
  after_create :create_initial_week
  after_create :setup_scoring

  state_machine :status, :initial => :active do
    event :finish do
      transition :active => :finished
    end
  end

  def get_total_league_points
    participants_by_standing.collect{|p| p.total_league_points}
  end

  def participants_by_standing
    participants.sort_by{|p| -p.total_league_points}
  end


  def get_message_board
    if message_board.nil?
      self.message_board = MessageBoard.new
      self.save
    end
    message_board
  end

  def get_all_invitations
    FantasyInvitation.where(fantasy_league_id: id)
  end

  def get_pending_invitations
    get_all_invitations.select{|i| i.status == "pending"}
  end

  def add_owner_as_participant
    participant = participants.create! user: user, is_owner: true
    participant.active
    Evently.record(self, 'added participant as owner', user)
  end

  def create_initial_week
    week = weeks.create!
    participants.where(status: :active).each do |participant|
      week.teams.create! participant: participant
    end
    Evently.record(self, 'created initial week', week)
  end

  def setup_scoring
    scorings.create category: "passing", sub_category: "yards", interval: 30, points: 1
    scorings.create category: "passing", sub_category: "tds", interval: 1, points: 4
    scorings.create category: "passing", sub_category: "ints", interval: 1, points: -2

    scorings.create category: "rushing", sub_category: "yards", interval: 10, points: 1
    scorings.create category: "rushing", sub_category: "tds", interval: 1, points: 6

    scorings.create category: "receiving", sub_category: "receptions", interval: 1, points: 1
    scorings.create category: "receiving", sub_category: "yards", interval: 15, points: 1
    scorings.create category: "receiving", sub_category: "tds", interval: 1, points: 6

    scorings.create category: "fumbles", sub_category: "", interval: 1, points: -2

    Evently.record(self, 'created default scoring')
  end

  def current_week
    weeks.where(week_number: current_week_number).first
  end

  def owner
    participant = participants.where(is_owner: true).first.user
  end

  def has_owner?
    !participants.where(is_owner: true).count.zero?
  end

  def is_participant?(participant)
    count = participants.where(user_id: participant.user.id).count
    !count.zero?
  end

  def increment_current_week_number
    self.current_week_number += 1
    self.save
  end

end