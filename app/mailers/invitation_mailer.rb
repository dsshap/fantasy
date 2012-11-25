class InvitationMailer < ActionMailer::Base

  default :from => "dss.shapiro@gmail.com"

  def invite(email, league_name, link)
    @league_name = league_name
    @email = email
    @link = link
    mail(:to => email,
         :subject => "Invite")
  end

end