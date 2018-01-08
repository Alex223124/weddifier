module ApplicationHelper
  def guest_invite_status(guest)
    if guest.invited?
      'Invited'
    else
      link_to 'Invite', guest_invitations_path(guest), method: :post,
        remote: true
    end
  end

  def guest_remove_link(guest)
    if guest.invited?
      ''
    else
      link_to 'Remove', guest_path(guest), method: :delete, data:
        { confirm: 'Are you sure?' }
    end
  end
end
