ActiveAdmin.register FantasyLeague do
  #actions :index, :show, :new, :edit, :create, :update

  controller do

    def new_fantasy_week
      fantasy_league = FantasyLeague.find(params[:fantasy_league_id])
      fantasy_league.current_week.complete
      week = fantasy_league.weeks.create!
      fantasy_league.participants.where(status: :active).each do |participant|
        week.teams.create! participant: participant
      end
      redirect_to admin_fantasy_league_fantasy_week_path(fantasy_league, week)
    end

  end

  action_item :only => :show do
    link_to("New Fantasy Week", admin_fantasy_league_new_fantasy_week_path(params[:id]))
  end

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
        column(:user){|p| link_to p.user.email, admin_user_path(p.user)}
        column :is_owner
        column :status
        column :updated_at
        column :created_at
      end
    end

    panel "Invitations" do
      table_for fantasy_league.get_all_invitations do
        column :email
        column :status
      end
    end

    panel "Weeks" do
      table_for fantasy_league.weeks do
        column(:week_number){|week| link_to "Week #{week.week_number}", admin_fantasy_league_fantasy_week_path(fantasy_league, week) }
        column :status
        column :updated_at
        column :created_at
      end
    end
  end
end
