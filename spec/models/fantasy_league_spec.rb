require 'spec_helper'

describe FantasyLeague do

  context 'creation' do

    it 'should not be a valid name' do
      league = FantasyLeague.new

      league.should_not be_valid
      league.errors[:name].should include('can\'t be blank')
    end

    it 'should not be valid without owner' do
      league = FantasyLeague.new name: "Test League Name"

      league.should_not be_valid
      league.errors[:owner].should include('needs an owner')
    end

    it 'should not be valid without owner' do
      user = FactoryGirl.create(:user)
      league = FantasyLeague.new name: "Test League Name"
      league.participants.new user: user

      league.should_not be_valid
      league.errors[:owner].should include('needs an owner')
    end

    it 'should be valid' do
      user = FactoryGirl.create(:user)
      league = FantasyLeague.new name: "Test League Name"
      league.participants.new user: user, is_owner:true

      league.should be_valid
      league.owner.id.should eq(user.id)
    end

    it 'should create' do
      user = FactoryGirl.create(:user)
      league = FantasyLeague.new name: "Test League Name"
      league.participants.new user: user, is_owner:true
      league.save

      FantasyLeague.all.first.id.should eql(league.id)
    end

    it 'should create a week' do
      user = FactoryGirl.create(:user)
      league = FantasyLeague.new name: "Test League Name"
      league.weeks

    end

  end

end