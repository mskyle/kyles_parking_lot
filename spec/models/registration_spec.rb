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
    before { @registration = FactoryGirl.create(:registration) }
    it { should_not have_valid(:spot_number).when(@registration.spot_number)}
  end
end
