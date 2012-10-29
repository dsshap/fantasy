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
    @league_owner = current_user.fantasy_leagues.collect(&:id).include?(@fantasy_league.id)
    @week = @fantasy_league.current_week
    @team = nil
    unless @week.has_team?(current_user)
      @team = @week.teams.create! participant: current_user
    else
      @team = @week.current_team(current_user)
    end
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