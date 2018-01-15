class PlusOnesController < ApplicationController
  before_action :require_leader_registration
  before_action :redirect_if_already_registered

  def new
    @leader = Guest.find params[:guest_id]
    @plus_one = Guest.new
  end

  def create
    @leader = Guest.find params[:guest_id]
    @plus_one = Guest.new(guest_params)

    if @plus_one.save
      @leader.plus_one = @plus_one
      @leader.save

      session[:plus_one_id] = @plus_one.id
      flash[:success] = 'You have successfully registered a plus one.'
      redirect_to thank_you_path
    else
      flash[:danger] = 'There are some errors in your form.'
      render :new
    end
  end

  private

  def guest_params
    params.require(:plus_one).permit(:first_name, :last_name, :father_surname,
      :mother_surname, :email, :phone)
  end

  def require_leader_registration
    unless session[:guest_id]
      flash[:danger] = 'Please register yourself first.'
      redirect_to root_path
    end
  end

  def redirect_if_already_registered
    if session[:plus_one_id]
      flash[:danger] = 'You have already registered your plus one.'
      redirect_to thank_you_path
    end
  end
end
