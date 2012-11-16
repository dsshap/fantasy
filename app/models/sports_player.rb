class SportsPlayer

  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :sports_week

  field :name
  field :team 
  field :position
  field :opponent, default: ""

  embeds_many :stats, class_name: 'SportsStatistic', cascade_callbacks: true do
    def find_by_stat(category, sub_category)
      where(category: category, sub_category: sub_category).first
    end
  end

  attr_accessible :name, :team, :position, :opponent, :stats_attributes
  accepts_nested_attributes_for :stats, :allow_destroy => true

  after_create :set_up_stats

  state_machine :status, :initial => :eligible do
    event :in_play do
      transition :eligible => :playing
    end
    event :done do
      transition :playing => :done
    end
  end

  def set_up_stats
    stats.create category: "passing", sub_category: "yards", value: 0
    stats.create category: "passing", sub_category: "tds", value: 0
    stats.create category: "passing", sub_category: "ints", value: 0

    stats.create category: "rushing", sub_category: "yards", value: 0
    stats.create category: "rushing", sub_category: "tds", value: 0

    stats.create category: "receiving", sub_category: "receptions", value: 0
    stats.create category: "receiving", sub_category: "yards", value: 0
    stats.create category: "receiving", sub_category: "tds", value: 0

    stats.create category: "fumbles", sub_category: "", value: 0

  end

end