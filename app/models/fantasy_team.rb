class FantasyTeam

  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :fantasy_week


  field :participant_id,        type: Moped::BSON::ObjectId



end