class SportsWeek

  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :sports_league

  embeds_many :players, class_name: "SportsPlayer", cascade_callbacks: true

  accepts_nested_attributes_for :players, :allow_destroy => true

end