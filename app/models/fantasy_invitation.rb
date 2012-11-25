class FantasyInvitation

  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :fantasy_league

  field :email

  attr_accessible :email

  validates :email,   
            :presence => true,
            :uniqueness => true,     
            :format => { :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i }

  state_machine :status, :initial => :pending do
    event :accepted do
      transition :pending => :accepted
    end
  end

  after_create :send_invite

  def send_invite
    FantasyInvitationEmailWorker.perform_async(id)
  end

  def join_league_link
    "http://www.oldtownsports.com/fantasy_leagues/#{fantasy_league.id}/join_league/#{id}"
  end

  def join_league(user)
    if user.email.eql?(email)
      if fantasy_league.participants.where(user_id: user.id).count.zero?
        p "participant doesn't exist"
        participant = fantasy_league.participants.create! user: user
        participant.active
        p "creating team"
        fantasy_league.current_week.teams.create! participant: participant
        accepted
        p "done"
      end
    end
  end

end