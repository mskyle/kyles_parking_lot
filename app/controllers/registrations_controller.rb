class RegistrationsController < ApplicationController

  def new
    @registration = Registration.new
    @last_registration_id = session[:last_registration_id]
    @last_registration = Registration.find_by_id(@last_registration_id)
    @yesterday_registration = nil    
    if @last_registration.try(:parked_on) == Date.today.days_ago(1)
      @yesterday_registration = @last_registration
    end
  end

  def create
    @registration = Registration.new(reg_params)
    if @registration.park
      session[:last_registration_id] = @registration.id
      redirect_to @registration, notice: "You registered successfully."
    else
      render :new
    end
  end

  def show
    @registration = Registration.find(params[:id])
  end

  def index 
    @registrations = Registration.all
    @last_registration_id = session[:last_registration_id]
    @last_registration = Registration.find_by_id(@last_registration_id)
    @my_registrations = @last_registration.history
  end

protected

  def reg_params
    params.require(:registration).permit(
      :first_name,
      :last_name,
      :email,
      :spot_number)
  end

end
