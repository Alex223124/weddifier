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
    offset = params[:offset]

    # Only change order if clicking on same link.
    if params[:query] == attribute
      new_order = (params[:order] == 'asc' ? 'desc' : 'asc')

      link_to admin_path(query: attribute, order: new_order, link: link_name, offset: offset) do
        select_fa_icon(link_name, params[:order])
      end
    # Else start ascending.
    else
      link_to admin_path(query: attribute, order: 'asc', link: link_name, offset: offset) do
        sort_name = link_name == 'Plus one / Leader' ? 'filter' : 'sort'

        fa_icon sort_name, text: link_name
      end
    end
  end

  def select_fa_icon(link_name, order)
    link_name = link_name.strip

    icon = case link_name
      when 'Invited', 'Signed up at' then fa_icon "sort-#{order}"
      when 'Phone'                   then fa_icon "sort-numeric-#{order}"
      when 'Plus one / Leader'       then fa_icon 'filter'
      else                                fa_icon "sort-alpha-#{order}"
      end

    icon + ' ' + link_name
  end

  def to_filter_name(attribute)
    first, last = attribute.split('_')
    [first.capitalize, last].join(' ')
  end

  def format_date(date)
    time_ago_in_words(date.in_time_zone('America/Mexico_City'),
      include_seconds: true) + ' ago' + ' / ' +
      date.in_time_zone('America/Mexico_City').strftime("%A %d %b %l:%M%P")
  end

  def sort_status(query, order, link_name)
    desc = (order == 'desc')

    if query && order
      string_order = case query
      when 'invited_at', 'created_at'
        desc ? "Recent to Old" : "Old to Recent"
      when 'relationship'
        desc ? 'Guests without plus one' : 'Guests with plus one'
      when 'invited'
        desc ? "confirmed first" : "non-invited first"
      else
        desc ? "Z-A / 9-0" : "A-Z / 0-9"
      end

      "#{link_name}, #{string_order}"
    else
      'No sorts / filters'
    end
  end

  def generate_pages_array(page_number)
    return [] unless page_number

    requested_offset = params[:offset]

    (0...page_number).each_with_object([]) do |n, array_of_link_pages|
      offset = n * Guest::PER_PAGE

      # If no pagination requested, first page (n == 0) will be a string.
      # Or if there is indeed a pagination request, make the current page that
      # matches that offset to a string.
      if (requested_offset.nil? && n == 0) || requested_offset.to_s == (offset).to_s
        array_of_link_pages << "| Page #{n + 1}"

      # Other pages will be links instead of strings.
      else
        array_of_link_pages << (link_to "| Page #{n + 1}", admin_path(
          offset: offset, link: params[:link], order: params[:order],
          query: params[:query]))
      end
    end
  end

  # -- Total guests sizes --

  def all_guests_size(guests)
    Guest.all.size
  end

  def invited_guests_size(guests)
    Guest.where(invited: true).size
  end

  def remaining_to_invite_guests_size(guests)
    all_guests_size(guests) - invited_guests_size(guests)
  end

  def confirmed_guests_size(guests)
    Guest.where("invitations.fulfilled IS TRUE").references(:invitations).size
  end
end
