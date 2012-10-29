ActiveAdmin.register FantasyWeek do
  actions :show, :edit, :update

  controller do

    def show
      @fantasy_week = get_week
    end

    def edit
      puts "In edit"
      @fantasy_week = get_week
    end




    def get_week
      fantasy_week = nil
      FantasyLeague.where(status: :active).each do |league|
        league.weeks.each do |week|
          if week.id.to_s.eql?(params[:id])
            fantasy_week = week
            break
          end
        end
        unless fantasy_week.nil?
          break
        end
      end
      fantasy_week
    end

  end

  show :title => :week_number do # "Week #{:id} for leage: #{:fantasy_league}" do
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
        column(:id){|team| link_to team.id, nil }
        column(:participant){|team| link_to team.participant.email, admin_user_path(team.participant) }
        column :status
        column :updated_at
        column :created_at
      end
    end
  end

  form do |f|
   f.inputs "Fantasy Week Details" do
     f.input :id
     f.input :week_number
     f.input :status
   end
   #TODO need buttons
 end
  
end
