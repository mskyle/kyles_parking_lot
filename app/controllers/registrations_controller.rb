class RegistrationsController < ApplicationController

  def new
    @registration = Registration.new
    @last_registration_id = session[:last_registration_id]
  end

  def create
    @registration = Registration.new(reg_params)
    if @registration.park
      session[:last_registration_id] = @registration.id
      flash[:notice] = "You registered successfully. #{@registration.neighbor_message}"
      redirect_to '/'
    else
      render :new
    end
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
