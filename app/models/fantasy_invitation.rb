class FantasyInvitation

  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :fantasy_league

  field :email
  field :inviter_email

  attr_accessible :email, :inviter_email

  validates :email,
            :presence => true,
            :format => { :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i }

  state_machine :status, :initial => :pending do
    event :accepted do
      transition :pending => :accepted
    end
  end

  after_create :send_invite

  def name
    "#{email} invitation"
  end

  def send_invite
    FantasyInvitationEmailWorker.perform_async(id)
    Evently.record(fantasy_league, 'invited', email, self)
  end

  def join_league_link
    "http://www.oldtownsports.com/fantasy_leagues/#{fantasy_league.id}/join_league/#{id}"
  end

  def join_league(user)
    if user.email.eql?(email)
      if fantasy_league.participants.where(user_id: user.id).count.zero?
        participant = fantasy_league.participants.create! user: user
        participant.active
        team = fantasy_league.current_week.teams.create! participant: participant
        accepted

        Evently.record(user, "accepted invite to", fantasy_league)
        Evently.record(user, "added as participant to", fantasy_league)
        Evently.record(user, "created a new team", team)

      end
    end
  end

end