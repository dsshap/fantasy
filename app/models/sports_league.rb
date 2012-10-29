class SportsLeague

  include Mongoid::Document
  include Mongoid::Timestamps

  field :name,                     default: 'football'
  field :current_week_number,      type: Integer, default: 1

  embeds_many :weeks, class_name: 'SportsWeek', cascade_callbacks: true do
    def number(week_number)
      where(week_number: week_number).first
    end
  end

  attr_accessible :name, :current_week_number
  accepts_nested_attributes_for :weeks, :allow_destroy => true

  validates_presence_of :name

  state_machine :status, :initial => :active do
    event :finish do
      transition :active => :finished
    end
  end

  def increment_current_week_number
    self.current_week_number += 1
    self.save
  end

  def self.get_sport(sport_name) 
    SportsLeague.where(name: sport_name, status: :active).first
    
  end

end

# class Football < SportsLeague

#   def intitialize
#     self.name = "football"
#     super
#   end

# end