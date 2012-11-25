class SessionsController < Devise::SessionsController
  def create
    resource = warden.authenticate!(auth_options)
    set_flash_message(:notice, :signed_in) if is_navigational_format?
    sign_in(resource_name, resource)

    unless session[:invitation_ids].nil?
      session[:invitation_ids].each do |invitation_id|
        inv = FantasyInvitation.find(invitation_id)
        inv.join_league(resource)
      end
      session[:invitation_ids] = nil
    end

    respond_with resource, :location => after_sign_in_path_for(resource)
  end
end