ActiveAdmin.register SportsPlayer do
  config.clear_action_items!
  menu false

  controller do

    

    def new
      @sports_league = SportsLeague.find(params[:sports_league_id])
      @sports_week = @sports_league.weeks.find(params[:sports_week_id])
      @sports_player = @sports_week.players.new
      render 'new', layout: "active_admin"
    end

    def create
      sports_league = SportsLeague.find(params[:sports_league_id])
      sports_week = sports_league.weeks.find(params[:sports_week_id])
      sports_player = sports_week.players.new params[:sports_player]

      if sports_player.save!
        respond_with sports_player, location: admin_sports_league_sports_week_sports_player_path(sports_league, sports_week, sports_player)
      else
        respond_with sports_player, location: edit_admin_sports_league_sports_week_sports_player_path(sports_league, sports_week, sports_player)
      end
    end

    def show
      @sports_league = SportsLeague.find(params[:sports_league_id])
      @sports_week = @sports_league.weeks.find(params[:sports_week_id])
      @sports_player = @sports_week.players.find(params[:id])
    end

    def edit
      @sports_league = SportsLeague.find(params[:sports_league_id])
      @sports_week = @sports_league.weeks.find(params[:sports_week_id])
      @sports_player = @sports_week.players.find(params[:id])
      render 'edit',layout: "active_admin"
    end

    def update
      sports_player = SportsLeague.find(params[:sports_league_id]).weeks.find(params[:sports_week_id]).players.find(params[:id])
      sports_player.update_attributes params[:sports_player]
      if sports_player.save!
        respond_with sports_player, :location => admin_sports_league_sports_week_sports_player_path(params[:sports_league_id], params[:sports_week_id], params[:id])
      else
        respond_with sports_player, :location => admin_sports_league_sports_week_sports_player_path(params[:sports_league_id], params[:sports_week_id], params[:id])
      end
    end

    def destroy
      sports_player = SportsLeague.find(params[:sports_league_id]).weeks.find(params[:sports_week_id]).players.find(params[:id])
      sports_player.destroy
      redirect_to admin_sports_league_sports_week_path(params[:sports_league_id], params[:sports_week_id])
    end

  end

  action_item :only => :show do
    links = ''
    links<<link_to("Edit Sports Player", edit_admin_sports_league_sports_week_sports_player_path(params[:sports_league_id], params[:sports_week_id], sports_player))
    unless sports_player.sports_week.completed?
      links<<link_to("Delete Sports Player", admin_sports_league_sports_week_sports_player_path(params[:sports_league_id], params[:sports_week_id], sports_player), method: :delete)
    end
    links.html_safe
  end

  # form :partial => "form"

  show do
    attributes_table do
      row :id 
      row(:sports_league){|player| player.sports_week.sports_league.name}
      row(:sports_week){|player| player.sports_week.week_number}
      row :name
      row :team
      row :position
      row :opponent
      row :status
    end

    panel "Statistics" do
      table_for sports_player.stats do
        column(:category){|s| s.category.capitalize}
        column(:sub_category){|s| s.sub_category.capitalize}
        column :value
      end
    end
  end


end