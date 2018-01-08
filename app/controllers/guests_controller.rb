class GuestsController < ApplicationController
  before_action :redirect_if_already_registered

  def new
    @guest = Guest.new
  end

  def create
    @guest = Guest.new(guest_params)

    if @guest.save
      flash[:success] = 'You have successfully registered.'
      session[:guest_id] = @guest.id
      redirect_to thank_you_path
    else
      flash[:error] = 'There are some errors in your form.'
      render :new
    end
  end

  def destroy
    begin
      guest = Guest.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:error] = 'Guest does not exist.'
      return redirect_to admin_path
    end

    guest.destroy
    flash[:success] = "Successfully deleted #{guest.first_name}."
    redirect_to admin_path
  end

  private

  def guest_params
    params.require(:guest).permit(:first_name, :last_name, :father_surname,
      :mother_surname, :email, :phone)
  end

  def redirect_if_already_registered
    redirect_to home_path if guest_already_registered?
  end

  def guest_already_registered?
    !!session[:guest_id].present?
  end
end
