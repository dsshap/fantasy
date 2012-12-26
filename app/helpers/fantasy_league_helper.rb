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

  def show_participant_invitation_actions(inv)
    if @league_owner
      "#{inv.email} (#{link_to "re-send", fantasy_league_resend_invitation_path(inv.fantasy_league, inv)})".html_safe
    else
      "#{inv.email} (pending)"
    end
  end

  def team_name(team, extended=false)
    if team.participant.team_name.nil?
      "#{team.participant.user.email_prefix}"
    else
      name = "#{team.participant.team_name} "
      if extended
        name << "<small>#{team.participant.user.email_prefix}</small>"
      end
      name.html_safe
    end
  end


  def team_rank(team)
    participant_total_points = team.participant.total_league_points
    index = @total_points.index(participant_total_points) + 1

    msg = ""
    if @total_points.count(participant_total_points) > 1
      msg = "tied for "
    end
    msg << index.ordinalize
    if @total_points.count(participant_total_points) > 0
      msg << "&nbsp;&nbsp;&nbsp;&nbsp;[#{participant_total_points}]"
    end
    msg.html_safe
  end
end

