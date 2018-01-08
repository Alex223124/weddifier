module ApplicationHelper
  def guest_invite_status(guest)
    if guest.invited?
      'Invited'
    else
      link_to 'Invite', guest_invitations_path(guest), method: :post
    end
  end
end
