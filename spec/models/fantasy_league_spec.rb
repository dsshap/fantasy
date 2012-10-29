require 'spec_helper'

describe FantasyLeague do

  context 'creation' do

    it 'should not be a valid name' do
      league = FantasyLeague.new

      league.should_not be_valid
      league.errors[:name].should include('can\'t be blank')
    end

    it 'should be valid' do
      user = FactoryGirl.create(:user)
      league = user.fantasy_leagues.new name: "Test League Name"

      league.should be_valid
    end

    it 'should create and have one owner' do
      user = FactoryGirl.create(:user)
      league = user.fantasy_leagues.create! name: "Test League Name"

      league.has_owner?.should be_true
      league.current_week_number.should eq(1)
    end

    it 'should have one participant' do
      user = FactoryGirl.create(:user)
      league = user.fantasy_leagues.create! name: "Test League Name"

      league.participants.count.should eq(1)
    end    

    it 'should create a week' do
      user = FactoryGirl.create(:user)
      league = user.fantasy_leagues.create name: "Test League Name"
      week = league.weeks.create!
      
      league.weeks.count.should eq(1)
    end

    it 'should be valid team' do
      user = FactoryGirl.create(:user)
      league = user.fantasy_leagues.create name: "Test League Name"
      week = league.weeks.create!
      team = week.teams.new participant: league.participants.first.user

      team.should be_valid
    end

    it 'should create a team in a week' do
      user = FactoryGirl.create(:user)
      league = user.fantasy_leagues.create name: "Test League Name"
      week = league.weeks.create
      team = week.teams.create! participant: league.participants.first.user

      league.weeks.first.teams.count.should eq(1)
      league.weeks.first.teams.first.participant.id.should eq(league.participants.first.user.id)
      league.weeks.first.week_number.should eq(1)
    end

    it 'should not be valid team for participant not in league' do
      user = FactoryGirl.create(:user)
      league = user.fantasy_leagues.create name: "Test League Name"
      week = league.weeks.create
      week.teams.create! participant: league.participants.first.user
      user2 = FactoryGirl.create(:user2)
      team = week.teams.new participant: user2

      team.should_not be_valid
      team.errors[:participant].should include('user not part of league')
    end

    it 'should not be allowed to make more than one teams in one week' do
      user = FactoryGirl.create(:user)
      league = user.fantasy_leagues.create name: "Test League Name"
      week = league.weeks.create
      week.teams.create! participant: league.participants.first.user
      team = week.teams.new participant: league.participants.first.user

      team.should_not be_valid
      team.errors[:participant].should include('user already has a team for this week')
    end

  end

  it 'should increment current_week_number' do
    user = FactoryGirl.create(:user)
    league = user.fantasy_leagues.create name: "Test League Name"
    week = league.weeks.create
    week.complete

    league.current_week_number.should eq(2)
  end

  def create_sports_league
    league = SportsLeague.create name: "football"
    week = league.weeks.create
    week.players.create name: 'john doe', team: 'fake team', number: '0'
    league
  end

  def create_fantasy_league
    user = FactoryGirl.create(:user)
    league = user.fantasy_leagues.create name: "Test League Name"
    week = league.weeks.create
    week.teams.create! participant: league.participants.first.user
    league
  end

  it 'should find player' do
    s_league = create_sports_league
    f_league = create_fantasy_league
    s_player = s_league.weeks.first.players.first
    f_team = f_league.weeks.first.teams.first
    f_player = f_team.players.create player: s_player, position: 'QB'

    f_team.players.first.player.id.should eq(s_player.id)
  end

end