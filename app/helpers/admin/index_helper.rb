module Admin::IndexHelper
  def guest_invite_status(guest)
    if guest.invited?
      button_to 'Invited', admin_path, remote: true, disabled: true,
        class: 'btn btn-outline-success'
    else
      link_to 'Invite', guest_invitations_path(guest), remote: true,
        method: :post, class: 'btn btn-success'
    end
  end

  def guest_remove_link(guest)
    return '' if guest.invited?

    if guest.leader?
      link_to 'Remove', guest_path(guest), method: :delete, data:
        { confirm: 'Deleting a leader will delete his plus one, are you'\
        ' sure you want to continue?' },
        remote: true, class: 'btn btn-outline-danger'
    elsif guest.plus_one?
      link_to 'Remove', guest_path(guest), method: :delete, data:
        { confirm: "You are deleting #{guest.leader.full_name}'s plus one."\
          ' Are you sure you want to continue?' },
        remote: true, class: 'btn btn-outline-danger'
    else
      link_to 'Remove', guest_path(guest), method: :delete, data:
        { confirm: 'Are you sure?' },
        remote: true, class: 'btn btn-outline-danger'
    end
  end

  def admin_filter(attribute, link_name = to_filter_name(attribute))
    # Only change order if clicking on same link.
    if params[:query] == attribute
      if params[:order] == 'desc'
        link_to link_name, admin_path(query: attribute, order: 'asc', link: link_name)
      elsif params[:order] == 'asc'
        link_to link_name, admin_path(query: attribute, order: 'desc', link: link_name)
      end
    # Else start ascending.
    else
      link_to link_name, admin_path(query: attribute, order: 'asc', link: link_name)
    end
  end

  def to_filter_name(attribute)
    first, last = attribute.split('_')
    [first.capitalize, last].join(' ')
  end

  def format_date(date)
    date.in_time_zone('America/Mexico_City').strftime("%A %d %B %l:%M%P") # 03/14/2014 9:09pm
  end
end
