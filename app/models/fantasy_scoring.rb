class FantasyScoring

  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :fantasy_league

  field :category
  field :sub_category
  field :interval,        type: Integer
  field :points,          type: Integer

  attr_accessible :category, :sub_category, :interval, :points

end
