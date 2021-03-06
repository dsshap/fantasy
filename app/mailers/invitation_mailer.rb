class InvitationMailer < ActionMailer::Base

  default :from => "Old Town Sports<team@oldtownsports.com>",
          :reply_to => "pinkyandthebrain@oldtownsports.com"

  def invite(email, name, code, inviter_email)

    @league_name = name
    @email = email
    @code = code
    @inviter_email = inviter_email
    mail(:to => email,
         :subject => "Old Town Sports Invitation to Fantasy League: #{@league_name}")
  end

end