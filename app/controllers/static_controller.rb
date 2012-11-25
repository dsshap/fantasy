class StaticController < ApplicationController
  layout :decide_which_layout 

  def home
    if user_signed_in?
      redirect_to root_path and return
    end
    render layout: 'static'
  end

  def contact
  end

  def faq
  end

  def waiting_for_confirmation
    @provider = Provider.find(params[:provider_id])
  end

end