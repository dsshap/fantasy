class Participant

  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :fantasy_league

  field :user_id,       type: Moped::BSON::ObjectId
  field :is_owner,      type: Boolean,                  default: false

  attr_accessible :user_id, :user, :is_owner

  validates_presence_of :user_id

  def user=(user)
    if user.class.name.eql?('User')
      self.user_id = user.id
    end
  end

  def user
    @user ||= User.find(user_id) rescue nil
  end

end