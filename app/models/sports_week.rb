class SportsWeek

  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :sports_league

  field :week_number,         type: Integer

  has_many :players, class_name: "SportsPlayer"

  # embeds_many :players, class_name: "SportsPlayer", cascade_callbacks: true do
  #   def qb
  #     where(position: 'qb').to_a
  #   end

  #   def rb
  #     where(position: 'rb').to_a
  #   end

  #   def wr_te
  #     any_in(position: ['wr', 'te']).to_a
  #   end
  # end

  attr_accessible :week_number, :players, :players_attributes
  accepts_nested_attributes_for :players, :allow_destroy => true

  state_machine :status, :initial => :pending do
    after_transition :on => :complete, :do => :increment_week_number
    after_transition :on => :complete, :do => :make_all_player_done
    before_transition :on => :active, :do => :assign_week_number
    event :active do
      transition :pending => :active
    end
    event :complete do
      transition :active => :completed
    end
  end

  def qb
    players.where(position: 'qb').to_a
  end

  def rb
    players.where(position: 'rb').to_a
  end

  def wr_te
    players.any_in(position: ['wr', 'te']).to_a
  end

  def wr
    players.where(position: 'wr').to_a
  end

  def te
    players.where(position: 'te').to_a
  end

  def eligable_players
    players.where(status: 'eligible')
  end

  def in_play_players
    players.where(status: 'playing')
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

  def make_all_player_done
    players.collect(&:done)
    self.save
  end

  # def sports_league
  #   @sports_league ||= SportsLeague.find(sports_league_id) rescue nil
  # end

end