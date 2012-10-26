class Team

  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :week


  field :participant_id,        type: Moped::BSON::ObjectId



end