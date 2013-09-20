require 'spec_helper'
feature 'system remembers parker info from previous day', %q{
  As a parker
  I want to know what spot I parked in yesterday
  So that I can determine if I'm parking in the same spot
  } do

  # Also includes: 
  # As a parker
  # I want the system to suggest the last spot I parked in 
  # So that I don't have to re-enter the slot number

  # As a parker
  # I want the system to remember my email
  # So that I don't have to re-enter it
  
  # Acceptance Criteria:
  # * If I parked yesterday, the system tells me where I parked yesterday when checking in. 
  # * If I did not park yesterday, the system tells me that I did not park yesterday when checking in.
  # * If I parked before today, the system prefills my spot number with the spot I last parked in.
  # * If I have not parked, the system does not prefill the spot number.

  # Helper methods, not sure where I should put these? 

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

  scenario "returning user's email is remembered" do
    old_registration = FactoryGirl.build(:registration)

    visit new_registration_path 
    
    reg_form_fill_in(old_registration)

    visit new_registration_path

    expect(page).to have_field("Email", with: old_registration.email)
  end

  scenario "returning user's spot from yesterday is remembered" do
    old_registration = FactoryGirl.build(:registration)

    visit new_registration_path

    reg_form_fill_in(old_registration)
    
    change_reg_date(1)

    visit new_registration_path
    expect(page).to have_content("Yesterday you parked in spot number #{old_registration.spot_number}")
  end

  scenario "returning user's spot from yesterday is pre-filled in the form" do
    old_registration = FactoryGirl.build(:registration)

    visit new_registration_path

    reg_form_fill_in(old_registration)
    
    change_reg_date(1)

    visit new_registration_path
    expect(page).to have_field("Spot number", with: "#{old_registration.spot_number}")
  end

  scenario "if user didn't park yesterday it says so" do
    old_registration = FactoryGirl.build(:registration)

    visit new_registration_path

    reg_form_fill_in(old_registration)
    
    change_reg_date(2)

    visit new_registration_path
    expect(page).to have_content("You didn't park here yesterday")

  end

end