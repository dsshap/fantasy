ActiveAdmin.register FantasyWeek do
  actions :none
  config.clear_action_items!
  menu false

  controller do
    respond_to *Mime::SET.map(&:to_sym)
    def show
      @fantasy_week = FantasyLeague.find(params[:fantasy_league_id]).weeks.find(params[:id])
    end

    def edit
      @fantasy_league = FantasyLeague.find(params[:fantasy_league_id])
      @fantasy_week = @fantasy_league.weeks.find(params[:id])
    end

    def update
      fantasy_week = FantasyLeague.find(params[:fantasy_league_id]).weeks.find(params[:id])
      fantasy_week.update_attributes params[:fantasy_week]
      if fantasy_week.save!
        respond_with fantasy_week, :location => admin_fantasy_league_fantasy_week_path(params[:fantasy_league_id], params[:id])
      else
        respond_with fantasy_week, :location => edit_admin_fantasy_league_fantasy_week_path(params[:fantasy_league_id], params[:id])
      end
    end

  end

  action_item :only => :show do
    link_to("Edit Fantasy Week", edit_admin_fantasy_league_fantasy_week_path(params[:fantasy_league_id], fantasy_week))
  end

  form :partial => "form"

  show do
    attributes_table do
      row :id 
      row(:fantasy_league){|week| week.fantasy_league.name}
      row :week_number
      row :status
      row :updated_at
      row :created_at
    end

    panel "Teams" do
      table_for fantasy_week.teams do
        column(:team_id){|team| link_to team.id, admin_fantasy_league_fantasy_week_fantasy_team_path(team.fantasy_week.fantasy_league, team.fantasy_week, team) }
        column(:participant){|team| link_to team.participant.user.email, admin_user_path(team.participant) }
        column :status
        column :updated_at
        column :created_at
      end
    end
  end

  
end
