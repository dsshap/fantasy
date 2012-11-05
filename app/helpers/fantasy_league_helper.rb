module FantasyLeagueHelper

  def week_tab(week)
    class_str = ''

    if week.id.eql?(@week.id)
      class_str << 'active'
    end


    # unless params[:week_number].nil? 
    #   if week.week_number.eql?(params[:week_number].to_i)
    #     class_str << 'active'
    #   end
    # else
    #   if week.week_number.eql?(@fantasy_league.current_week_number)
    #     class_str << 'active'
    #   end
    # end
    class_str
  end

end

