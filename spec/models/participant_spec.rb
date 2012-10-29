require 'spec_helper'

describe Participant do

  context 'creation' do

    it 'should not be a valid user_id' do
      league = FantasyLeague.new name: "Test Name"  
      participant = league.participants.new

      participant.should_not be_valid
      participant.errors[:user_id].should include('can\'t be blank')
    end

    it 'should not be a valid user' do
      league = FantasyLeague.new name: "Test Name"  
      participant = league.participants.new user: nil

      participant.should_not be_valid
      participant.errors[:user_id].should include('can\'t be blank')
    end

  end

  context 'player selection' do

    # it 'should add '
  end

end