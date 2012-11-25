class FantasyInvitationEmailWorker

  include Sidekiq::Worker
  # sidekiq_options retry: false

  def perform(fantasy_invitation_id)
    inv = FantasyInvitation.find(fantasy_invitation_id) rescue nil

    unless inv.nil?
      InvitationMailer.invite(inv.email, inv.fantasy_league.name, inv.join_league_link).deliver
    end
  end

end