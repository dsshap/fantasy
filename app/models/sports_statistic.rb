class SportsStatistic

  include Mongoid::Document

  embedded_in :sports_player

  field :category
  field :value,       type: Integer

  attr_accessible :category, :value

end