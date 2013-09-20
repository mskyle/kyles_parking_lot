require 'spec_helper'

feature 'returning parkers can see their parking history', %q{
  As a parker
  I want to see a list of my parking activity
  So that I can see where I've parked over time
} do
  # Acceptance Criteria: 
  # * When checking in, if I've previously checked in with the same email, 
  #   I am given the option to see parking activity 
  # * If I opt to see parking activity, I am shown all of my check-ins 
  #   sorted in reverse chronological order. 
  #   I can see the spot number and the day and time I checked in. 
  # * If I have not previously checked in, I do not have the option to see parking activity

  scenario "user with previous registration sees they have history" do
    FactoryGirl.create(:registration, parked_on: Date.today.days_ago(1))
    FactoryGirl.create(:registration, parked_on: Date.today.days_ago(2))

    registration = FactoryGirl.build(:registration, parked_on: Date.today)

    visit new_registration_path

    reg_form_fill_in(registration)

    expect(page).to have_content("Parking history")

  end

  scenario "user with previous registrations can see their previous registrations in reverse date order" do
    old_reg_2 = FactoryGirl.create(:registration, parked_on: Date.today.days_ago(1))
    old_reg_1 = FactoryGirl.create(:registration, parked_on: Date.today.days_ago(2))

    registration = FactoryGirl.build(:registration, parked_on: Date.today)

    visit new_registration_path

    reg_form_fill_in(registration)
    click_on "Parking history" 
    expect(page).to have_content(registration.spot_number, old_reg_1.spot_number, old_reg_2.spot_number)
    registration.parked_on.to_s.should appear_before(old_reg_1.parked_on.to_s)

  end

  scenario "user with no previous registrations does not get link to history" do 
    registration = FactoryGirl.build(:registration, parked_on: Date.today)

    visit new_registration_path

    reg_form_fill_in(registration)
    expect(page).to have_no_content("Parking history")
  end

  scenario "user does not see other parkers' histories" do
    old_reg = FactoryGirl.create(:registration, email: "jeremey@bentham.com", parked_on: Date.today.days_ago(1))
    registration = FactoryGirl.build(:registration, parked_on: Date.today)

    visit new_registration_path

    reg_form_fill_in(registration)
    expect(page).to have_no_content("Parking history")
  end


  def reg_form_fill_in(registration)

    fill_in "First name", with: registration.first_name
    fill_in "Last name", with: registration.last_name
    fill_in "Spot number", with: registration.spot_number
    fill_in "Email", with: registration.email

    click_on "New registration"
  
  end

  def change_reg_date(days_back)
    last_registration = Registration.last
    last_registration.parked_on = Date.today.days_ago(days_back)
    last_registration.save
  end


end