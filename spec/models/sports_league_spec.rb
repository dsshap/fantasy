require 'spec_helper'

describe SportsLeague do

  context 'creation' do

    it 'should be a valid name' do
      league = SportsLeague.new

      league.should be_valid
    end

    it 'should create league' do
      league = SportsLeague.create name: "test sport"

      league.current_week_number.should eq(1)
    end

    it 'should have created an initial week' do
      league = SportsLeague.create name: "test sport"


      league.weeks.count.should eq(1)
      league.weeks.first.week_number.should eq(1)
      league.current_week_number.should eq(1)
    end

    it 'should add a player to a week' do
      league = SportsLeague.create name: "test sport"
      week = league.weeks.first
      week.players.create name: 'john doe', team: 'fake team', number: '0'

      league.weeks.first.players.count.should eq(1)
      league.weeks.first.players.first.name.should eq('john doe')
      league.weeks.first.players.first.team.should eq('fake team')
      league.weeks.first.players.first.number.should eq('0')
    end

  end

  it 'should add a statistic to a player' do
    league = SportsLeague.create name: "test sport"
    week = league.weeks.first
    player = week.players.create name: 'john doe', team: 'fake team', number: '0'

    league.weeks.first.players.first.stats.count.should eq(9)
    #TODO check values categories sub-categories
  end

  it 'should increment current week number' do
    league = SportsLeague.create name: "test sport"
    week = league.weeks.create
    week.active
    week.complete

    league.current_week_number.should eq(2)
  end

end