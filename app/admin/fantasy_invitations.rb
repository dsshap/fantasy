ActiveAdmin.register FantasyInvitation do

  index do
    column :id
    column :email
    column :status
    column :created_at
    column :updated_at
    default_actions
  end

end
