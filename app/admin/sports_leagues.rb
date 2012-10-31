ActiveAdmin.register SportsLeague do

  controller do

    def new_sports_week
      sports_league = SportsLeague.find(params[:sports_league_id])
      week = sports_league.weeks.create
      redirect_to admin_sports_league_sports_week_path(sports_league, week)
    end

  end

  action_item :only => :show do
    link_to("New Sports Week", admin_sports_league_new_sports_week_path(params[:id]))
  end

  index do
    column(:name){|league| link_to league.name, admin_sports_league_path(league)}
    column :current_week_number
    column :status
    column :created_at
    default_actions
  end
  
  show do
    attributes_table do
      row :id 
      row :name
      row :current_week_number
      row :status
      row :updated_at
      row :created_at
    end

    panel "Weeks" do
      table_for sports_league.weeks do
        column(:week_number){|week| link_to((week.week_number.nil? ? "not set yet" : week.week_number), admin_sports_league_sports_week_path(week.sports_league, week))}
        column :status
        column :updated_at
        column :created_at
      end
    end
  end

end
