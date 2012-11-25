class ApplicationController < ActionController::Base  
  protect_from_forgery
  layout :decide_which_layout

protected

  def decide_which_layout
    if user_signed_in?
      p "app"
      'application'
    else
      p "static"
      'static'
    end
  end

  def set_invitation_into_session(invite_id)
    if session[:invitation_ids].nil?
      session[:invitation_ids] = Array.new
    end
    session[:invitation_ids].push(invite_id)
  end

end
