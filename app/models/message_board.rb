class MessageBoard

  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :fantasy_league

  embeds_many :posts, class_name: 'MessageBoardPost', cascade_callbacks: true

  attr_accessible :posts_attributes
  accepts_nested_attributes_for :posts, :allow_destroy => true

end


class MessageBoardPost

  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :message_board

  field :text
  field :participant_id,        type: Moped::BSON::ObjectId

  validates_presence_of :text, :participant_id

  def participant=(participant)
    if participant.class.name.eql?('FantasyParticipant')
      self.participant_id = participant.id
    end
  end

  def participant
    @participant ||= message_board.fantasy_league.participants.find(participant_id) rescue nil
  end

end