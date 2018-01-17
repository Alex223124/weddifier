module Admin::IndexHelper
  def guest_invite_status(guest)
    if guest.invited?
      if guest.accepted_invitation?
        button_to admin_path, remote: true, disabled: true,
          class: 'btn btn-primary', id: 'confirmed-button' do
          fa_icon 'check', text: 'Confirmed'
        end
      else
        button_to admin_path, remote: true, disabled: true,
          class: 'btn' do
          fa_icon 'hourglass', text: 'Invited'
        end
      end

    else
      link_to guest_invitations_path(guest), remote: true,
        method: :post, class: 'btn btn-success' do
        fa_icon 'paper-plane', text: 'Invite'
      end
    end
  end

  def guest_remove_link(guest)
    return '' if guest.invited?

    if guest.leader?
      link_to guest_path(guest), method: :delete, data:
        { confirm: 'Deleting a leader will delete his plus one, are you'\
        ' sure you want to continue?' },
        remote: true, class: 'btn btn-outline-danger' do
        fa_icon 'trash', text: 'Remove'
      end

    elsif guest.plus_one?
      link_to guest_path(guest), method: :delete, data:
        { confirm: "You are deleting #{guest.leader.full_name}'s plus one."\
          ' Are you sure you want to continue?' },
        remote: true, class: 'btn btn-outline-danger' do
        fa_icon 'trash', text: 'Remove'
      end

    else
      link_to guest_path(guest), method: :delete, data:
        { confirm: 'Are you sure?' },
        remote: true, class: 'btn btn-outline-danger' do
        fa_icon 'trash', text: 'Remove'
      end
    end
  end

  def admin_filter(attribute, link_name = to_filter_name(attribute))
    # Only change order if clicking on same link.
    if params[:query] == attribute
      new_order = (params[:order] == 'asc' ? 'desc' : 'asc')

      link_to admin_path(query: attribute, order: new_order, link: link_name) do
        select_fa_icon(link_name, params[:order])
      end
    # Else start ascending.
    else
      link_to admin_path(query: attribute, order: 'asc', link: link_name) do
        sort_name = link_name == 'Plus one / Leader' ? 'filter' : 'sort'

        fa_icon sort_name, text: link_name
      end
    end
  end

  def select_fa_icon(link_name, order)
    link_name = link_name.strip

    icon =
      if link_name == 'Invited' || link_name == 'Signed up at'
        fa_icon "sort-#{order}"
      elsif link_name == 'Phone'
        fa_icon "sort-numeric-#{order}"
      elsif link_name == 'Plus one / Leader'
        fa_icon 'filter'
      else
        fa_icon "sort-alpha-#{order}"
      end

    icon + ' ' + link_name
  end

  def to_filter_name(attribute)
    first, last = attribute.split('_')
    [first.capitalize, last].join(' ')
  end

  def format_date(date)
    date.in_time_zone('America/Mexico_City').strftime("%A %d %B %l:%M%P")
  end
end
