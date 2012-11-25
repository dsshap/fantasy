require 'spec_helper'

describe FantasyInvitation do

  context 'creation' do

    it 'should not be a valid email' do
      user = FactoryGirl.create(:user)
      league = user.fantasy_leagues.create! name: "Test League Name"

      inv = league.invitations.new email: 'test.com'

      inv.should_not be_valid
    end

    it 'should not be a valid email' do
      user = FactoryGirl.create(:user)
      league = user.fantasy_leagues.create! name: "Test League Name"

      inv = league.invitations.new email: 'test@com'

      inv.should_not be_valid
    end

    it 'should be valid' do
      user = FactoryGirl.create(:user)
      league = user.fantasy_leagues.create! name: "Test League Name"

      inv = league.invitations.new email: 'test@mail.com'
      inv.should be_valid
    end

    it 'should submit to job' do
      user = FactoryGirl.create(:user)
      league = user.fantasy_leagues.create! name: "Test League Name"
      inv = league.invitations.create! email: 'test@mail.com'

      assert_equal 1, FantasyInvitationEmailWorker.jobs.size
      FantasyInvitationEmailWorker.jobs.clear
    end

  end

end
