require 'spec_helper'

feature "parkers can't check into spots that already have cars in them", %q{
  As a parker
  I cannot check in to a spot that has already been checked in
  So that two cars are not parked in the same spot
  } do
  # Acceptance Criteria:

  # * If I specify a parking spot that has already been checked in for the day, I am told I can't check in there.
  # * If I specify a spot that hasn't yet been parked in today, I am able to check in.

  scenario 'user attempts to register a space that is already in use' do 

    visit new_registration_path
    fill_in "First name", with: "Kyle"
    fill_in "Last name", with: "Hutchinson"
    fill_in "Spot number", with: 30
    fill_in "Email", with: "kyle@hutchinson.com"

    click_on "New registration"

    prev_count = Registration.count 

    visit new_registration_path
    fill_in "First name", with: "Kyle"
    fill_in "Last name", with: "Hutchinson"
    fill_in "Spot number", with: 30
    fill_in "Email", with: "kyle@hutchinson.com"

    click_on "New registration"

    expect(Registration.count).to eql(prev_count)
    expect(page).to have_content("Spot number has already been taken")
  end

  scenario 'user can register a space that is not already in use' do 

    visit new_registration_path
    fill_in "First name", with: "Kyle"
    fill_in "Last name", with: "Hutchinson"
    fill_in "Spot number", with: 30
    fill_in "Email", with: "kyle@hutchinson.com"

    click_on "New registration"

    prev_count = Registration.count 

    visit new_registration_path
    fill_in "First name", with: "Kyle"
    fill_in "Last name", with: "Hutchinson"
    fill_in "Spot number", with: 31
    fill_in "Email", with: "kyle@hutchinson.com"

    click_on "New registration"

    expect(Registration.count).to eql(prev_count + 1)
    expect(page).to have_content("You registered successfully")
  end

end