class SportsLeague

  include Mongoid::Document
  include Mongoid::Timestamps

  field :name

  embeds_many :weeks, class_name: 'SportsWeek', cascade_callbacks: true

  attr_accessible :name
  accepts_nested_attributes_for :weeks, :allow_destroy => true

  validates_presence_of :name

end