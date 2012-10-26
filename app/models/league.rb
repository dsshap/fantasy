class League

  include Mongoid::Document
  include Mongoid::Timestamps

  field :name

  #has_and_belongs_to_many :users, as: :participants, autosave: true
  embeds_many :weeks, cascade_callbacks: true
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