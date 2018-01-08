class InvitationsController < ApplicationController
  def create
    guest = Guest.find(params[:guest_id])

    if guest.invited?
      flash[:error] = 'Guest was already invited.'
      return redirect_to admin_path
    else
      invitation = Invitation.create
      guest.invitation = invitation

      ApplicationMailer.send_invite(guest.id).deliver

      flash[:success] = "Successfully invited guest #{guest.first_name}"\
        " #{guest.last_name} #{guest.father_surname} #{guest.mother_surname} -"\
        " #{guest.email}."
      redirect_to admin_path
    end
  end
end
