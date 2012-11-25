class RegistrationsController < Devise::RegistrationsController

  # POST /resource
  def create
    build_resource

    if resource.save

      Evently.record(resource, "signed-up")

      unless session[:invitation_ids].nil?
        session[:invitation_ids].each do |invitation_id|
          inv = FantasyInvitation.find(invitation_id)
          inv.join_league(resource)
        end
        session[:invitation_ids] = nil
      end

      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_in(resource_name, resource)
        respond_with resource, :location => after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
        expire_session_data_after_sign_in!
        respond_with resource, :location => after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      respond_with resource
    end

  end
  
end