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
      flash[:danger] = 'There are some errors in your form.'
      render :new
    end
  end

  def destroy
    begin
      @guest = Guest.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:danger] = 'Guest does not exist.'
      return redirect_to admin_path
    end

    flash_message = "Successfully removed guest #{@guest.first_name}"\
          " #{@guest.last_name} #{@guest.father_surname}"\
          " #{@guest.mother_surname} - #{@guest.email}."
    @guest.destroy

    respond_to do |format|
      format.html do
        flash[:success] = flash_message
        redirect_to admin_path
      end

      format.js do
        @flash = js_flash(flash_message, :success)
        render :destroy
      end
    end
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
