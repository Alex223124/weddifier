class InvitationsController < ApplicationController
  before_action :require_admin

  def create
    @guest = Guest.find(params[:guest_id])

    if @guest.invited?
      flash[:error] = 'Guest was already invited.'
      return redirect_to admin_path
    else
      flash_message = "Successfully invited guest #{@guest.first_name}"\
          " #{@guest.last_name} #{@guest.father_surname}"\
          " #{@guest.mother_surname} - #{@guest.email}."
      respond_to do |format|

        format.html do
          flash[:success] = flash_message
          redirect_to admin_path
        end

        format.js do
          @flash = js_flash(flash_message, :success)
          render :create
        end
      end

      invitation = Invitation.create(guest: @guest)
    end
  end

  def bulk_create
    unless params[:guest_ids]
      flash[:warning] = 'Please select a guest.'
      return redirect_to admin_path
    end

    ActiveRecord::Base.transaction do
      params[:guest_ids].each do |guest_id|
        guest = Guest.find guest_id

        next if guest.invited?

        Invitation.create!(guest: guest)
      end
    end

    flash[:success] = 'Guests invited successfully.'
    redirect_to admin_path
  end
end
