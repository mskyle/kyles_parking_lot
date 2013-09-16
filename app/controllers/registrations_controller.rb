class RegistrationsController < ApplicationController

  def new
    @registration = Registration.new
  end

  def create
    @registration = Registration.new(reg_params)
    if @registration.park
      flash[:notice] = 'You registered successfully'
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
