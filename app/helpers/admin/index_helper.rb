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
    if guest.invited?
      raw ''
    else
      link_to 'Remove', guest_path(guest), method: :delete, data:
        { confirm: 'Are you sure?' }, remote: true, class: 'btn btn-outline-danger'
    end
  end

  def admin_filter(attribute, link_name = to_filter_name(attribute))
    if params[:order].blank? || params[:order] == 'desc'
      link_to link_name, admin_path(query: attribute, order: 'asc')
    elsif params[:order] == 'asc'
      link_to link_name, admin_path(query: attribute, order: 'desc')
    end
  end

  def to_filter_name(attribute)
    first, last = attribute.split('_')
    [first.capitalize, last].join(' ')
  end

  def format_date(date)
    date.strftime("%A %d %B %l:%M%P") # 03/14/2014 9:09pm
  end
end
