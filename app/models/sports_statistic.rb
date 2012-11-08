class SportsStatistic

  include Mongoid::Document

  embedded_in :sports_player

  field :category
  field :sub_category
  field :value,       type: Integer

  attr_accessible :category, :sub_category, :value

end