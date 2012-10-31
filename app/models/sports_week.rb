class SportsWeek

  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :sports_league

  field :week_number,         type: Integer

  embeds_many :players, class_name: "SportsPlayer", cascade_callbacks: true

  attr_accessible :week_number
  accepts_nested_attributes_for :players, :allow_destroy => true

  state_machine :status, :initial => :pending do
    after_transition :on => :complete, :do => :increment_week_number
    before_transition :on => :active, :do => :assign_week_number
    event :active do
      transition :pending => :active
    end
    event :complete do
      transition :active => :completed
    end
  end

  def name
    "Week: #{week_number}"
  end

  def assign_week_number
    self.week_number = sports_league.current_week_number
  end

  def increment_week_number
    sports_league.increment_current_week_number
  end

end