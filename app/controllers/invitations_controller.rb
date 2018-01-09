class InvitationsController < ApplicationController
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
end
