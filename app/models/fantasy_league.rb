class FantasyLeague

  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user

  field :name
  field :current_week_number,      type: Integer, default: 1
  field :sport,                    default: 'football'

  embeds_many :weeks, class_name: 'FantasyWeek', cascade_callbacks: true
  embeds_many :participants, class_name: 'FantasyParticipant', cascade_callbacks: true

  attr_accessible :name, :current_week_number
  accepts_nested_attributes_for :weeks, :participants, :allow_destroy => true

  validates_presence_of :name

  after_create :add_owner_as_participant
  after_create :create_initial_week

  state_machine :status, :initial => :active do
    event :finish do
      transition :active => :finished
    end
  end

  def add_owner_as_participant
    participants.create user: user, is_owner: true
  end

  def create_initial_week
    weeks.create!
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
    count = participants.where(user_id: participant.id).count
    !count.zero?
  end

  def increment_current_week_number
    self.current_week_number += 1
    self.save
  end

end