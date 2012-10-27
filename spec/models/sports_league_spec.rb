require 'spec_helper'

describe SportsLeague do

  context 'creation' do

    it 'should not be a valid name' do
      league = SportsLeague.new

      league.should_not be_valid
      league.errors[:name].should include('can\'t be blank')
    end

    it 'should create a new week' do
      league = SportsLeague.create name: "test sport"
      league.weeks.create

      league.weeks.count.should eq(1)
    end

    it 'should add a player to a week' do
      league = SportsLeague.create name: "test sport"
      week = league.weeks.create
      week.players.create name: 'john doe', team: 'fake team', number: '0'

      league.weeks.first.players.count.should eq(1)
      league.weeks.first.players.first.name.should eq('john doe')
      league.weeks.first.players.first.team.should eq('fake team')
      league.weeks.first.players.first.number.should eq('0')
    end

  end

  it 'should add a statistic to a player' do
    league = SportsLeague.create name: "test sport"
    week = league.weeks.create
    player = week.players.create name: 'john doe', team: 'fake team', number: '0'
    player.stats.create category: 'td', value: 1

    league.weeks.first.players.first.stats.count.should eq(1)
    league.weeks.first.players.first.stats.first.category.should eq("td")
    league.weeks.first.players.first.stats.first.value.should eq(1)
  end

end