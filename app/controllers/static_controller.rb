class StaticController < ApplicationController
  layout 'static'

  def home
  end

  def pricing
  end

  def contact
  end

  def faq
  end

  def waiting_for_confirmation
    @provider = Provider.find(params[:provider_id])
  end

end