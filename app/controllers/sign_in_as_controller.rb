class SignInAsController < ApplicationController
  before_filter :authenticate_admin_user!

  def create
    user = User.find(params[:user_id]) rescue nil
    unless user.nil?
      sign_in(:user, user)
    end
    redirect_to root_path
  end

end