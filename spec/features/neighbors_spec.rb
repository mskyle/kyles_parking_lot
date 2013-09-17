require 'spec_helper'

feature "parkers can see their neighbors", %q{
  As a parker
  I want to see my two neighbors
  So that I can get to know them better
  } do 

  # Acceptance Criteria:

  # After checking in, if I have a neighbor in a slot 1 below me, or one above me, I am informed of their name and what slot number they are currently in
  # If I do not have anyone parking next to me, I am told that I have no current neighbors

  scenario 'parker parks between two other cars' do
    FactoryGirl.create(:registration, { :spot_number => 40} )
    FactoryGirl.create(:registration, { :spot_number => 42} ) 
    visit "/"
    fill_in "First name", with: "Joey"
    fill_in "Last name", with: "Jo-Jo-Shabadou"
    fill_in "Spot number", with: 41
    fill_in "Email", with: "j@shabadou.com"
    click_on "New registration"

    expect(page).to have_content("Your neighbors are", "40", "42")
  end

  scenario 'parker parks next to one other car' do
    FactoryGirl.create(:registration, { :spot_number => 40} )

    visit "/"
    fill_in "First name", with: "Joey"
    fill_in "Last name", with: "Jo-Jo-Shabadou"
    fill_in "Spot number", with: 41
    fill_in "Email", with: "j@shabadou.com"
    click_on "New registration"

    expect(page).to have_content("Your neighbor is", "40")
  end

  scenario 'parker parks next to no other cars' do
    visit "/"
    fill_in "First name", with: "Joey"
    fill_in "Last name", with: "Jo-Jo-Shabadou"
    fill_in "Spot number", with: 41
    fill_in "Email", with: "j@shabadou.com"
    click_on "New registration"

    expect(page).to have_content("You have no current neighbors.")
  end
end