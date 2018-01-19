require 'rails_helper'

feature 'Admin uses pagination' do
  background do
    100.times do |n|
      Fabricate(:guest,
        first_name: "User #{n + 1}",
        last_name: "User #{n + 1}",
        father_surname: "User #{n + 1}",
        mother_surname: "User #{n + 1}",
        email: "email#{n + 1}@test.com",
        created_at: (n + 1).minutes.ago)
    end

    admin_browser_login
  end

  scenario 'Admin visits admin path and sees pages' do
    # Guest::PER_PAGE is 25
    expect(page).to have_content('| Page 1 | Page 2 | Page 3 | Page 4')
    expect(page).not_to have_content('| Page 5')
  end

  scenario 'Admin uses pagination without sorting' do
    # Recently joined guests are at top.
    recent, last = [Guest.first, Guest.last]
    expect(page).to have_content /\b#{recent.first_name}\b/
    expect(page).not_to have_content /\b#{last.first_name}\b/

    click_link 'Page 4'

    expect(page).not_to have_content /\b#{recent.first_name}\b/
    expect(page).to have_content /\b#{last.first_name}\b/
  end

  scenario 'Admin sorts by first name and uses pagination' do
    sort_by_and_navigate_pages('first_name')
  end

  scenario 'Admin sorts by last name and uses pagination' do
    sort_by_and_navigate_pages('last_name')
  end

  scenario 'Admin sorts by father surname and uses pagination' do
    sort_by_and_navigate_pages('father_surname')
  end

  scenario 'Admin sorts by mother surname and uses pagination' do
    sort_by_and_navigate_pages('mother_surname')
  end

  scenario 'Admin sorts by email and uses pagination' do
    sort_by_and_navigate_pages('email')
  end

  scenario 'Admin sorts by phone and uses pagination' do
    sort_by_and_navigate_pages('phone')
  end


  scenario 'Admin sorts by invited and uses pagination' do
    Fabricate(:invitation, guest: Guest.first)
    visit admin_path

    guests_ordered_by_invited = Guest.order_by_invited('asc')
    first, last = [guests_ordered_by_invited.first, guests_ordered_by_invited.last]

    # Non invited got at the top
    expect(first.invited).to be false

    click_link 'Invited'
    expect(page).to have_content /\b#{first.first_name}\b/
    expect(page).not_to have_content /\b#{last.first_name}\b/

    click_link 'Page 4'
    expect(page).not_to have_content /\b#{first.first_name}\b/
    expect(page).to have_content /\b#{last.first_name}\b/
  end

  scenario 'Admin sorts by signed up at and uses pagination' do
    guests_ordered_by_created = Guest.order_by('created_at', 'asc')
    first, last = [guests_ordered_by_created.first, guests_ordered_by_created.last]

    click_link 'Signed up at'
    expect(page).to have_content /\b#{first.first_name}\b/
    expect(page).not_to have_content /\b#{last.first_name}\b/

    click_link 'Page 4'
    expect(page).not_to have_content /\b#{first.first_name}\b/
    expect(page).to have_content /\b#{last.first_name}\b/
  end

  scenario 'Admin sorts by invited at and uses pagination' do
    Fabricate(:invitation, guest: Guest.first)
    visit admin_path

    guests_ordered_by_invited_at = Guest.order_by_invited_at('asc')
    first, last = [guests_ordered_by_invited_at.first, guests_ordered_by_invited_at.last]

    click_link 'Invited at'
    expect(page).to have_content /\b#{first.first_name}\b/
    expect(page).not_to have_content /\b#{last.first_name}\b/

    click_link 'Page 4'
    expect(page).not_to have_content /\b#{first.first_name}\b/
    expect(page).to have_content /\b#{last.first_name}\b/
  end

  scenario 'Admin filters by plus one / leader and uses pagination' do
    leader = Guest.first
    leader.plus_one = Guest.second
    leader.save
    visit admin_path

    # This is a filter, rather than a sort.
    # 'asc' => Show leaders (guests with plus ones)
    # 'desc' => Show plus ones and normal guests.
    guest_with_plus_one = Guest.order_by_relationship('asc').first
    guest_without_plus_one = Guest.order_by_relationship('desc').first

    click_link 'Plus one / Leader'
    expect(page).to have_content /\b#{guest_with_plus_one.first_name}\b/
    expect(page).not_to have_content /\b#{guest_without_plus_one.first_name}\b/

    click_link 'Page 4'
    expect(page).not_to have_content /\b#{guest_with_plus_one.first_name}\b/
    expect(page).not_to have_content /\b#{guest_without_plus_one.first_name}\b/

    visit admin_path
    click_link 'Plus one / Leader'
    click_link 'Plus one / Leader'
    expect(page).not_to have_content /\b#{guest_with_plus_one.first_name}\b/
    expect(page).to have_content /\b#{guest_without_plus_one.first_name}\b/

    click_link 'Page 4'
    expect(page).not_to have_content /\b#{guest_with_plus_one.first_name}\b/
    expect(page).not_to have_content /\b#{guest_without_plus_one.first_name}\b/
  end

  def sort_by_and_navigate_pages(attribute)
    guests_ordered_by_az = Guest.order_by(attribute, 'asc')
    first, last = [guests_ordered_by_az.first, guests_ordered_by_az.last]
    link_name = attribute.capitalize.split('_').join(' ')

    click_link link_name
    expect(page).to have_content /\b#{first.send(attribute.to_sym)}\b/
    expect(page).not_to have_content /\b#{last.send(attribute.to_sym)}\b/

    click_link 'Page 4'
    expect(page).not_to have_content /\b#{first.send(attribute.to_sym)}\b/
    expect(page).to have_content /\b#{last.send(attribute.to_sym)}\b/
  end
end
