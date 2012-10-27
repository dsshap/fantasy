class SportsPlayer

  include Mongoid::Document
  include Mongoid::Timestamps::Created

  embedded_in :sports_week

  field :name
  field :team 
  field :number

  embeds_many :stats, class_name: 'SportsStatistic', cascade_callbacks: true

  attr_accessible :name, :team, :number

end