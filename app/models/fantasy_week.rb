class FantasyWeek

  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :fantasy_league

  embeds_many :teams, class_name: 'FantasyTeam', cascade_callbacks: true

  accepts_nested_attributes_for :teams

end