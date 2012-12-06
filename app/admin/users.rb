ActiveAdmin.register User do
  actions :index, :show, :new, :edit, :create, :update

  index do
    column(:email){|user| link_to user.email, admin_user_path(user)}
    column :current_sign_in_at
    column :last_sign_in_at
    column :sign_in_count
    default_actions
  end

  filter :email, :as => :string

  show do
    attributes_table do
      row :id
      row :email
      row(:sign_in_as){|u| link_to "sign in as", sign_in_as_path(:user_id => u.id) }
    end

    panel "Fantasy Leagues (Owner)" do
      table_for user.fantasy_leagues do
        column("Name"){|league| link_to league.name, admin_fantasy_league_path(league)}
        column :sport
        column :status
        column :created_at
      end
    end

    panel "Fantasy Leagues (Participating In)" do
      participating_in = user.leagues_belong_to - user.fantasy_leagues
      table_for participating_in do
        column("Name"){|league| link_to league.name, admin_fantasy_league_path(league)}
        column :sport
        column :status
        column :created_at
      end
    end

  end

  sidebar "Tracking Details", :only => :show do
    attributes_table_for user do
      row :sign_in_count
      row :current_sign_in_at
      row :last_sign_in_at
      row :current_sign_in_ip
      row :last_sign_in_ip
    end
  end

  sidebar "Password Details", :only => :show do
    attributes_table_for user do
      row :remember_created_at
      row :encrypted_password
      row :reset_password_token
      row :reset_password_sent_at
    end
  end


end