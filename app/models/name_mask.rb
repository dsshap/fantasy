class NameMask

  include Mongoid::Document

  field :name
  field :type

  attr_accessible :name, :type

  validates_presence_of :name, :type
  validates_uniqueness_of :name

end