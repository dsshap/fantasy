class FantasyLeaguesController < ApplicationController
  respond_to *Mime::SET.map(&:to_sym)# if mimes_for_respond_to.empty?

  def new
    @fantasy_league = current_user.fantasy_leagues.new 
  end

  def create
    fantasy_league = current_user.fantasy_leagues.new params[:fantasy_league]
    if fantasy_league.save
      flash[:notice] = "Created league: #{fantasy_league.name}"
      respond_with fantasy_league, :location => fantasy_league_path(fantasy_league)
    else
      respond_with fantasy_league
    end
  end

  def show
    @fantasy_league = FantasyLeague.find(params[:id])
    @current_user_participant = @fantasy_league.participants.where(user_id: current_user.id).first
    @league_owner = @current_user_participant.is_owner
    unless params[:week_number].nil? or (params[:week_number].to_i > @fantasy_league.current_week_number or params[:week_number].to_i < 0)
      puts "good week number"
      @week = @fantasy_league.weeks.where(week_number: params[:week_number]).first
    end

    if @week.nil?
      @week = @fantasy_league.current_week
    end
    
    @team = @week.current_team(@current_user_participant)
  end

  def edit
    @fantasy_league = FantasyLeague.find(params[:id])
  end

  def update
    fantasy_league = FantasyLeague.find(params[:id])
    fantasy_league.update_attributes params[:fantasy_league]
    if fantasy_league.save
      flash[:notice] = "Updated League Settings"
      respond_with fantasy_league, :location => fantasy_league_path(fantasy_league)
    else
      respond_with fantasy_league
    end
  end

end