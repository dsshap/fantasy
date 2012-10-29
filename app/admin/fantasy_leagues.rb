ActiveAdmin.register FantasyLeague do
  #actions :index, :show, :new, :edit, :create, :update

  index do
    column(:name){|league| link_to league.name, admin_fantasy_league_path(league)}
    column :sport
    column :status
    column :created_at
    default_actions
  end

  show do
    attributes_table do
      row :id 
      row :name
      row :sport
      row :status
      row(:owner){|league| league.user}
      row :current_week_number
      row :updated_at
      row :created_at
    end

    panel "Participants" do
      table_for fantasy_league.participants do
        column :user
        column :is_owner
        column :updated_at
        column :created_at
      end
    end

    panel "Weeks" do
      table_for fantasy_league.weeks do
        column(:week_number){|week| link_to week.week_number, admin_fantasy_week_path(week) }
        column :status
        column :updated_at
        column :created_at
      end
    end
  end
end
