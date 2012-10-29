class ApplicationController < ActionController::Base  
  protect_from_forgery
  layout :decide_which_layout

protected

  def decide_which_layout
    if user_signed_in?
      'application'
    else
      'static'
    end
  end

end
