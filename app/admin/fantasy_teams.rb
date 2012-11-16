ActiveAdmin.register FantasyTeam do
  actions :none
  config.clear_action_items!
  menu false
  
  controller do
    respond_to *Mime::SET.map(&:to_sym)
    def show
      @fantasy_team = FantasyLeague.find(params[:fantasy_league_id]).weeks.find(params[:fantasy_week_id]).teams.find(params[:id])
    end

    def edit
      @fantasy_league = FantasyLeague.find(params[:fantasy_league_id])
      @fantasy_week = @fantasy_league.weeks.find(params[:fantasy_week_id])
      @fantasy_team = @fantasy_week.teams.find(params[:id])
    end

    def update
      fantasy_team = FantasyLeague.find(params[:fantasy_league_id]).weeks.find(params[:fantasy_week_id]).teams.find(params[:id])
      fantasy_team.update_attributes params[:fantasy_team]
      if fantasy_team.save!
        respond_with fantasy_team, :location => admin_fantasy_league_fantasy_week_fantasy_team_path(params[:fantasy_league_id], params[:fantasy_week_id], params[:id])
      else
        respond_with fantasy_team, :location => edit_admin_fantasy_league_fantasy_week_fantasy_team_path(params[:fantasy_league_id], params[:fantasy_week_id], params[:id])
      end
    end

  end

  action_item :only => :show do
    link_to("Edit Fantasy Team", edit_admin_fantasy_league_fantasy_week_fantasy_team_path(params[:fantasy_league_id], params[:fantasy_week_id], fantasy_team))
  end

  form :partial => "form"

  show do # "Week #{:id} for leage: #{:fantasy_league}" do
    attributes_table do
      row :id 
      row(:fantasy_league){|team| team.fantasy_week.fantasy_league.name}
      row(:fantasy_week){|team| team.fantasy_week.week_number}
      row(:participant){|team| team.participant.user.email}
      row :status
      row :updated_at
      row :created_at
    end

    panel "Players" do
      table_for fantasy_team.players do
        column(:player) {|f_player| link_to(f_player.player.name, admin_sports_league_sports_week_sports_player_path(f_player.player.sports_week.sports_league, f_player.player.sports_week, f_player.player)) if f_player.has_player? }
        column(:postition){|f_player| f_player.position.upcase}
        # column(:id){|team| link_to team.id, nil }
        # column(:participant){|team| link_to team.participant.email, admin_user_path(team.participant) }
        # column :status
        # column :updated_at
        # column :created_at
      end
    end
  end

end
