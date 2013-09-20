require 'spec_helper'

describe Registration do
  it { should have_valid(:first_name).when("Jon") }
  it { should_not have_valid(:first_name).when("", nil) }

  it { should have_valid(:last_name).when("Bon Jovi") }
  it { should_not have_valid(:last_name).when("", nil) }

  it { should have_valid(:email).when("kyle@yes.com", "what+2@gmail.com") }
  it { should_not have_valid(:email).when("kyle.com", "foo", "foo@bar", 2, "", nil) }

  it { should have_valid(:spot_number).when(1,46, "23") }
  it { should_not have_valid(:spot_number).when("", nil, "foo", 61) }

  it { should have_valid(:parked_on).when(Date.today) }
  it { should_not have_valid(:parked_on).when("", nil) } 

  describe 'duplicate checking' do
    it do
      prev_registration = FactoryGirl.create(:registration)
      registration = FactoryGirl.build(:registration, 
        spot_number: prev_registration.spot_number,
        parked_on: prev_registration.parked_on) 
      expect(registration.park).to be_false
      expect(registration).to_not be_valid
    end
  end

  describe 'neighbor finder' do

    it 'shows neighbors when you have two neighbors' do
      FactoryGirl.create(:registration, { :spot_number => 40} )
      FactoryGirl.create(:registration, { :spot_number => 42} ) 
      new_registration = FactoryGirl.build(:registration, spot_number: 41)
      expect(new_registration.find_neighbors).to be_true
      expect(new_registration.neighbor_message).to include("Your neighbors are", "40", "42")
    end

    it 'shows one neighbor when you have only one neighbor' do
      FactoryGirl.create(:registration, { :spot_number => 40} )
      new_registration = FactoryGirl.build(:registration, spot_number: 41)
      expect(new_registration.find_neighbors).to be_true
      expect(new_registration.neighbor_message).to include("Your neighbor is", "40")
    end

    it 'tells you when you have no neighbors' do
      new_registration = FactoryGirl.build(:registration, spot_number: 41)
      expect(new_registration.find_neighbors).to eql([])
      expect(new_registration.neighbor_message).to eql("You have no current neighbors.")
    end

    it 'checks to make sure the neighbor is there on the same day as you' do
      FactoryGirl.create(:registration, { :spot_number => 40, :parked_on => Date.today.days_ago(1) } )
      FactoryGirl.create(:registration, { :spot_number => 42, :parked_on => Date.today.days_ago(2) }) 
      new_registration = FactoryGirl.build(:registration, spot_number: 41)
      expect(new_registration.find_neighbors).to be_true
      expect(new_registration.neighbor_message).to include("You have no current neighbors.")
    end
  end

  describe 'history' do
    it 'returns a list of all your previous registrations' do
       FactoryGirl.create(:registration, { :spot_number => 40, :parked_on => Date.today.days_ago(1) } )
       FactoryGirl.create(:registration, { :spot_number => 40, :parked_on => Date.today.days_ago(2) } )
       FactoryGirl.create(:registration, { :spot_number => 40, :parked_on => Date.today.days_ago(3) } )
      new_registration = FactoryGirl.build(:registration)
      expect(new_registration.history).to be_true
      expect(new_registration.history.count).to eql(3)      
    end
  end

end
