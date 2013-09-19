require 'spec_helper'

feature 'a parker registers her spot', %q{
  As a parker
  I want to register my spot with my name
  So that the parking company can identify my car
} do
  # Also includes: 
  # Acceptance Criteria:

  # I must specify a first name, last name, email, and parking spot number
  # I must enter a valid parking spot number (the lot has spots identified as numbers 1-60)
  # I must enter a valid email

  scenario 'user specifies correct information' do
    prev_count = Registration.count
    visit "/"

    fill_in "First name", with: "Kyle"
    fill_in "Last name", with: "Hutchinson"
    fill_in "Spot number", with: 30
    fill_in "Email", with: "kyle@hutchinson.com"

    click_on "New registration"
    expect(Registration.count).to eql(prev_count + 1)
    expect(page).to have_content("You registered successfully")
  end

  scenario 'user supplies insufficent information' do
    prev_count = Registration.count
    visit "/"

    click_on "New registration"

    expect(Registration.count).to eql(prev_count)
    expect(page).to have_content("can't be blank")
  
  end

  scenario 'user supplies an invalid parking spot number' do
    prev_count = Registration.count
    visit "/"

    fill_in "First name", with: "Kyle"
    fill_in "Last name", with: "Hutchinson"
    fill_in "Spot number", with: 62
    fill_in "Email", with: "kyle@hutchinson.com"

    click_on "New registration"
    expect(Registration.count).to eql(prev_count)
    expect(page).to have_content("Spot number must be")
  end

  scenario 'user supplies an invalid email' do
    prev_count = Registration.count
    visit "/"

    fill_in "First name", with: "Kyle"
    fill_in "Last name", with: "Hutchinson"
    fill_in "Spot number", with: 59
    fill_in "Email", with: "kylehutchinson.com"

    click_on "New registration"
    expect(Registration.count).to eql(prev_count)
    expect(page).to have_content("Email is invalid")
  end

end