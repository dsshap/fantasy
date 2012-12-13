ActiveAdmin.register SportsPlayingTime do

  controller do
    def set_in_play
      spt = SportsPlayingTime.find(params[:id]) rescue nil
      unless spt.nil?
        spt.set_players_to_active
      end
      redirect_to admin_sports_playing_time_path(spt)
    end

    def set_to_done
      spt = SportsPlayingTime.find(params[:id]) rescue nil
      unless spt.nil?
        spt.set_players_to_done
      end
      redirect_to admin_sports_playing_time_path(spt)
    end
  end

  index do
    column :playing_time
    default_actions
  end

  action_item :only => :show do
    link_to("Put Players Into Play", { :controller => "admin/sports_playing_times", :action => "set_in_play", :id =>params[:id] }, confirm: "Are you sure they are now playing?")+
    link_to("Player are Done", set_to_done_admin_sports_playing_time_path(params[:id]), confirm: "Are you sure they are done playing?")
  end

  form do |f|
    f.inputs "Sports Playing Times" do
      f.input :playing_time, :as => :just_datetime_picker
    end
    f.buttons
  end

end
