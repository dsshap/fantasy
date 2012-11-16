ActiveAdmin.register SportsWeek do
  actions :none
  config.clear_action_items!
  menu false

  controller do
    respond_to *Mime::SET.map(&:to_sym)
    def show
      @sports_week = SportsLeague.find(params[:sports_league_id]).weeks.find(params[:id])
    end

    def edit
      @sports_league = SportsLeague.find(params[:sports_league_id])
      @sports_week = @sports_league.weeks.find(params[:id])
    end

    def update
      sports_week = SportsLeague.find(params[:sports_league_id]).weeks.find(params[:id])
      sports_week.update_attributes params[:sports_week]
      if sports_week.save!
        respond_with sports_week, :location => admin_sports_league_sports_week_path(params[:sports_league_id], params[:id])
      else
        respond_with sports_week, :location => edit_admin_sports_league_sports_week_path(params[:sports_league_id], params[:id])
      end
    end

    def destroy
      sports_league = SportsLeague.find(params[:sports_league_id])
      sports_week = sports_league.weeks.find(params[:id])
      unless sports_week.active?
        sports_week.destroy
      end
      redirect_to admin_sports_league_path(sports_league)

    end

    def activate_next_week
      sports_league = SportsLeague.find(params[:sports_league_id])
      sports_league.current_week.complete
      sports_week = sports_league.weeks.find(params[:sports_week_id])
      sports_week.active
      redirect_to admin_sports_league_sports_week_path(sports_league, sports_week)
    end

  end

  action_item :only => :show do
    links = ''
    unless sports_week.completed? or sports_week.active?
      links<<link_to("Activate Sports Week", admin_sports_league_sports_week_activate_next_week_path(params[:sports_league_id], sports_week), confirm: "Are you sure you want to activate this sports week?")
      links<<link_to("Edit Sports Week", edit_admin_sports_league_sports_week_path(params[:sports_league_id], sports_week))
    end

    unless sports_week.completed?
      links<<link_to("New Sports Player", new_admin_sports_league_sports_week_sports_player_path(params[:sports_league_id], sports_week))
    end

    unless sports_week.active? or sports_week.completed?
      links<<link_to("Delete Sports Week", admin_sports_league_sports_week_path(params[:sports_league_id], sports_week), method: :delete, confirm: "Are you sure you want to delete this sports week?")
    end

    links.html_safe
  end

  form :partial => "form"

  show do
    attributes_table do
      row :id 
      row(:sports_league){|week| week.sports_league.name}
      row :week_number
      row :status
      row :updated_at
      row :created_at
    end

    panel "Players" do
      table_for sports_week.players do
        column(:name){|player| link_to player.name, admin_sports_league_sports_week_sports_player_path(player.sports_week.sports_league, player.sports_week, player) }
        column :team
        column :position 
        column :status
        column :opponent
        column :updated_at
        column :created_at
      end
    end
  end

end