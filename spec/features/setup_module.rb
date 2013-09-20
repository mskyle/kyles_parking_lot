module LoginSetup

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