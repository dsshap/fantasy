class Week

  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :league

  embeds_many :teams, cascade_callbacks: true

  accepts_nested_attributes_for :teams

end