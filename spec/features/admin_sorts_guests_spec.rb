require 'rails_helper'

feature 'Admin sorts guests' do
  let!(:a_guest) { Fabricate(:guest, first_name: 'AAAAA', last_name: 'AAAAA',
    father_surname: 'AAAAA', mother_surname: 'AAAAA', email: 'a@a.com',
    phone: 1111111111) }
  let!(:b_guest) { Fabricate(:guest, first_name: 'BBBBB', last_name: 'BBBBB',
    father_surname: 'BBBBB', mother_surname: 'BBBBB', email: 'b@b.com',
    phone: 2222222222) }

  background do
    admin_browser_login
  end

  scenario 'Admin visits admin page and sees non invited guests on top' do
    c_guest = Fabricate(:guest, first_name: 'C', last_name: 'C',
      father_surname: 'C', mother_surname: 'C', email: 'c@c.com',
      phone: 3333333333)
    Fabricate(:invitation, guest: a_guest)
    visit admin_path

    expect(b_guest.first_name).to appear_before(a_guest.first_name)
  end

  scenario 'Admin visits admin page and sees most recent sign ups on top' do
    expect(b_guest.first_name).to appear_before(a_guest.first_name)
  end

  scenario 'Admin sorts guests by first name and clears sorts' do
    click_link 'First name'
    expect(page).to have_content 'Sorting by: First name, A-Z / 0-9'
    expect(a_guest.first_name).to appear_before(b_guest.first_name)

    click_link 'First name'
    expect(page).to have_content 'Sorting by: First name, Z-A / 9-0'
    expect(b_guest.first_name).to appear_before(a_guest.first_name)

    click_button 'Clear filters'
    expect(b_guest.first_name).to appear_before(a_guest.first_name)
  end

  scenario 'Admin sorts guests by last name' do
    click_link 'Last name'
    expect(page).to have_content 'Sorting by: Last name, A-Z / 0-9'
    expect(a_guest.last_name).to appear_before(b_guest.last_name)

    click_link 'Last name'
    expect(page).to have_content 'Sorting by: Last name, Z-A / 9-0'
    expect(b_guest.last_name).to appear_before(a_guest.last_name)
  end

  scenario 'Admin sorts guests by father surname' do
    click_link 'Father surname'
    expect(page).to have_content 'Sorting by: Father surname, A-Z / 0-9'
    expect(a_guest.father_surname).to appear_before(b_guest.father_surname)

    click_link 'Father surname'
    expect(page).to have_content 'Sorting by: Father surname, Z-A / 9-0'
    expect(b_guest.father_surname).to appear_before(a_guest.father_surname)
  end

  scenario 'Admin sorts guests by mother surname' do
    click_link 'Mother surname'
    expect(page).to have_content 'Sorting by: Mother surname, A-Z / 0-9'
    expect(a_guest.mother_surname).to appear_before(b_guest.mother_surname)

    click_link 'Mother surname'
    expect(page).to have_content 'Sorting by: Mother surname, Z-A / 9-0'
    expect(b_guest.mother_surname).to appear_before(a_guest.mother_surname)
  end

  scenario 'Admin sorts guests by email' do
    click_link 'Email'
    expect(page).to have_content 'Sorting by: Email , A-Z / 0-9'
    expect(a_guest.email).to appear_before(b_guest.email)

    click_link 'Email'
    expect(page).to have_content 'Sorting by: Email , Z-A / 9-0'
    expect(b_guest.email).to appear_before(a_guest.email)
  end

  scenario 'Admin sorts guests by phone' do
    click_link 'Phone'
    expect(page).to have_content 'Sorting by: Phone , A-Z / 0-9'
    expect(a_guest.phone).to appear_before(b_guest.phone)

    click_link 'Phone'
    expect(page).to have_content 'Sorting by: Phone , Z-A / 9-0'
    expect(b_guest.phone).to appear_before(a_guest.phone)
  end

  scenario 'Admin sorts guests by invited' do
    Fabricate(:invitation, guest: b_guest)
    visit admin_path

    click_link 'Invited'
    expect(page).to have_content 'Sorting by: Invited , non-invited first'
    expect(a_guest.first_name).to appear_before(b_guest.first_name)

    click_link 'Invited'
    expect(page).to have_content 'Sorting by: Invited , confirmed first'
    expect(b_guest.first_name).to appear_before(a_guest.first_name)
  end

  scenario 'Admin sorts guests by invited and sees non-invited first,'\
    'confirmed second and invited last' do
    # Non-invited: b_guest
    # Confirmed: a_guest
    # Invited: c_guest

    c_guest = Fabricate(:guest, first_name: 'CCCCC', last_name: 'CCCCC',
      father_surname: 'CCCCC', mother_surname: 'CCCCC', email: 'c@c.com',
      phone: 3333333333)
    c_guest_invitation = Fabricate(:invitation, guest: c_guest)

    a_guest_invitation = Fabricate(:invitation, guest: a_guest)
    a_guest_invitation.fulfill
    visit admin_path

    click_link 'Invited'
    expect(b_guest.first_name).to appear_before(a_guest.first_name)
    expect(a_guest.first_name).to appear_before(c_guest.first_name)
  end

  scenario 'Admin sorts guests by invited again, and sees confirmed first'\
    ', invited second and non invited last' do
      # Confirmed: a_guest
      # Invited: c_guest
      # Non-invited: b_guest

      c_guest = Fabricate(:guest, first_name: 'CCCCC', last_name: 'CCCCC',
        father_surname: 'CCCCC', mother_surname: 'CCCCC', email: 'c@c.com',
        phone: 3333333333)
      c_guest_invitation = Fabricate(:invitation, guest: c_guest)

      a_guest_invitation = Fabricate(:invitation, guest: a_guest)
      a_guest_invitation.fulfill
      visit admin_path

      click_link 'Invited'
      click_link 'Invited'
      expect(a_guest.first_name).to appear_before(c_guest.first_name)
      expect(c_guest.first_name).to appear_before(b_guest.first_name)
  end

  scenario 'Admin sorts guests by signed up at' do
    click_link 'Signed up at'
    expect(page).to have_content 'Sorting by: Signed up at, Old to Recent'
    expect(a_guest.first_name).to appear_before(b_guest.first_name)

    click_link 'Signed up at'
    expect(page).to have_content 'Sorting by: Signed up at, Recent to Old'
    expect(b_guest.first_name).to appear_before(a_guest.first_name)
  end

  scenario 'Admin sorts guests by invited at' do
    Fabricate(:invitation, guest: b_guest)
    visit admin_path

    expect(a_guest.first_name).to appear_before(b_guest.first_name)

    click_link 'Invited at'
    expect(page).to have_content 'Sorting by: Invited at, Old to Recent'
    expect(b_guest.first_name).to appear_before(a_guest.first_name)

    # Uninvited guests will always show up at the bottom.
    click_link 'Invited at'
    expect(page).to have_content 'Sorting by: Invited at, Recent to Old'
    expect(b_guest.first_name).to appear_before(a_guest.first_name)

    Fabricate(:invitation, guest: a_guest)
    visit admin_path

    # Now that they're both invited, the first invited is shown first.
    click_link 'Invited at'
    expect(b_guest.first_name).to appear_before(a_guest.first_name)

    click_link 'Invited at'
    expect(a_guest.first_name).to appear_before(b_guest.first_name)
  end

  scenario 'Admin sorts guests by plus one / leader, see guests that have'\
    'plus ones or see the ones that come alone' do
    c_guest = Fabricate(:guest, first_name: 'C', last_name: 'C',
      father_surname: 'C', mother_surname: 'C', email: 'c@c.com',
      phone: 3333333333)
    # A is the leader, B is the plus one.
    a_guest.plus_one = b_guest
    a_guest.save
    visit admin_path

    click_link 'Plus one / Leader'
    expect(page).to have_content 'Sorting by: Guests with plus one'
    expect(page.body).not_to include(c_guest.phone)
    expect(page.body).to include(a_guest.phone)
    expect(page.body).not_to include(b_guest.phone)


    click_link 'Plus one / Leader'
    expect(page).to have_content 'Sorting by: Guests without plus one'
    expect(page.body).to include(c_guest.phone)
    expect(page.body).not_to include(a_guest.phone)
    expect(page.body).not_to include(b_guest.phone)
  end

  scenario 'Admin sorts guests by plus one / leader, see guests that have'\
    'plus ones. Recently signed up guests at the top' do
    c_guest = Fabricate(:guest, first_name: 'C', last_name: 'C',
      father_surname: 'C', mother_surname: 'C', email: 'c@c.com',
      phone: 3333333333)

    d_guest = Fabricate(:guest, first_name: 'D', last_name: 'D',
      father_surname: 'D', mother_surname: 'D', email: 'd@d.com',
      phone: 4444444444)

    e_guest = Fabricate(:guest, first_name: 'E', last_name: 'E',
      father_surname: 'E', mother_surname: 'E', email: 'e@e.com',
      phone: 5555555555)


    a_guest.plus_one = b_guest
    a_guest.save

    c_guest.plus_one = e_guest
    c_guest.save
    visit admin_path

    click_link 'Plus one / Leader'
    expect(c_guest.phone).to appear_before(a_guest.phone)
  end

  scenario 'Admin sorts guests by plus one / leader, see non invited on top' do
    a_guest.plus_one = b_guest
    a_guest.save

    c_guest = Fabricate(:guest, first_name: 'CCCCC', last_name: 'CCCCC',
      father_surname: 'CCCCC', mother_surname: 'CCCCC', email: 'c@c.com',
      phone: 3333333333)
    d_guest = Fabricate(:guest, first_name: 'DDDDD', last_name: 'DDDDD',
      father_surname: 'DDDDD', mother_surname: 'DDDDD', email: 'd@d.com',
      phone: 4444444444)
    d_guest.plus_one = c_guest
    d_guest.save
    Fabricate(:invitation, guest: d_guest)

    visit admin_path
    click_link 'Plus one / Leader'
    expect(a_guest.first_name).to appear_before(d_guest.first_name)

    e_guest = Fabricate(:guest, first_name: 'EEEEE', last_name: 'EEEEE',
      father_surname: 'EEEEE', mother_surname: 'EEEEE', email: 'e@e.com',
      phone: 5555555555)

    f_guest = Fabricate(:guest, first_name: 'FFFFF', last_name: 'FFFFF',
      father_surname: 'FFFFF', mother_surname: 'FFFFF', email: 'f@f.com',
      phone: 6666666666)
    Fabricate(:invitation, guest: f_guest)

    visit admin_path
    click_link 'Plus one / Leader'
    click_link 'Plus one / Leader'
    expect(e_guest.first_name).to appear_before(f_guest.first_name)
  end

  scenario 'Admin clicks any sort, it should be ascending on first click.'\
    ' Clicking it again should sort descending. All the other filters should'\
    ' start ascending.' do
    click_link 'First name'
    expect(a_guest.first_name).to appear_before(b_guest.first_name)
    click_link 'First name'
    expect(b_guest.first_name).to appear_before(a_guest.first_name)

    visit admin_path

    click_link 'First name'
    click_link 'Last name'
    expect(a_guest.first_name).to appear_before(b_guest.first_name)
    click_link 'Last name'
    expect(b_guest.first_name).to appear_before(a_guest.first_name)
  end
end
