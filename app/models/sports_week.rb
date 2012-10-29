class SportsWeek

  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :sports_league

  field :week_number,         type: Integer

  embeds_many :players, class_name: "SportsPlayer", cascade_callbacks: true

  attr_accessible :week_number
  accepts_nested_attributes_for :players, :allow_destroy => true

  before_create :assign_week_number

  state_machine :status, :initial => :active do
    after_transition :on => :complete, :do => :increment_week_number
    event :complete do
      transition :active => :completed
    end
  end

  def assign_week_number
    self.week_number = sports_league.current_week_number
  end

  def increment_week_number
    sports_league.increment_current_week_number
  end

end