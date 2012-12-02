class InvitationMailer < ActionMailer::Base

  default :from => "Old Town Sports<team@oldtownsports.com>"
  default :reply_to => "pinkyandthebrain@oldtownsports.com"

  def invite(inv)
    inv.email, inv.fantasy_league.name, inv.join_league_link
    @league_name = inv.fantasy_league.name
    @email = inv.email
    @link = inv.join_league_link
    @inviter_email = inv.inviter_email
    mail(:to => email,
         :subject => "Old Town Sports Invitation to Fantasy League: #{league_name}")
  end

end