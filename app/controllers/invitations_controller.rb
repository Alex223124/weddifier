class InvitationsController < ApplicationController
  before_action :require_admin

  def create
    @guest = Guest.find(params[:guest_id])

    if @guest.invited?
      flash[:danger] = 'Guest was already invited.'
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
      message = 'Please select a guest.'

      respond_to do |format|
        format.html do
          flash[:warning] = message
          return redirect_to admin_path
        end

        format.js do
          @flash = js_flash(message, :warning)
          return render :bulk_create
        end
      end
    end

    bulk_invite(params[:guest_ids])

    respond_to do |format|
      message = 'Guests invited successfully.'

      format.html do
        flash[:success] = message
        redirect_to admin_path
      end

      format.js do
        @flash = js_flash(message, :success)
        @guest_ids = params[:guest_ids].map(&:to_i)
        render :bulk_create
      end
    end
  end

  private

  def bulk_invite(guest_ids)
    ActiveRecord::Base.transaction do
      params[:guest_ids].each do |guest_id|
        guest = Guest.find guest_id

        next if guest.invited?

        Invitation.create!(guest: guest)
      end
    end
  end
end
