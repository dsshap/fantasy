class FantasyLeague

  include Mongoid::Document
  include Mongoid::Timestamps

  field :name

  embeds_many :weeks, class_name: 'FantasyWeek', cascade_callbacks: true

  embeds_many :participants, cascade_callbacks: true


  attr_accessible :name
  accepts_nested_attributes_for :weeks, :participants, :allow_destroy => true

  validates_presence_of :name
  validate :has_owner


  def owner
    participant = participants.where(is_owner: true).first.user
  end

  def has_owner
    if participants.where(is_owner: true).count.zero?
      errors.add(:owner, 'needs an owner')
    end
  end

end