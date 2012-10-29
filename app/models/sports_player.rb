class SportsPlayer

  include Mongoid::Document
  include Mongoid::Timestamps::Created

  embedded_in :sports_week

  field :name
  field :team 
  field :position
  field :number

  embeds_many :stats, class_name: 'SportsStatistic', cascade_callbacks: true

  attr_accessible :name, :team, :position, :number

  state_machine :status, :initial => :eligible do
    event :in_play do
      transition :eligible => :playing
    end
    event :done do
      transition :playing => :done
    end
  end

end