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
    expect(a_guest.first_name).to appear_before(b_guest.first_name)

    click_link 'First name'
    expect(b_guest.first_name).to appear_before(a_guest.first_name)

    click_button 'Clear filters'
    expect(b_guest.first_name).to appear_before(a_guest.first_name)
  end

  scenario 'Admin sorts guests by last name' do
    click_link 'Last name'
    expect(a_guest.last_name).to appear_before(b_guest.last_name)

    click_link 'Last name'
    expect(b_guest.last_name).to appear_before(a_guest.last_name)
  end

  scenario 'Admin sorts guests by father surname' do
    click_link 'Father surname'
    expect(a_guest.father_surname).to appear_before(b_guest.father_surname)

    click_link 'Father surname'
    expect(b_guest.father_surname).to appear_before(a_guest.father_surname)
  end

  scenario 'Admin sorts guests by mother surname' do
    click_link 'Mother surname'
    expect(a_guest.mother_surname).to appear_before(b_guest.mother_surname)

    click_link 'Mother surname'
    expect(b_guest.mother_surname).to appear_before(a_guest.mother_surname)
  end

  scenario 'Admin sorts guests by email' do
    click_link 'Email'
    expect(a_guest.email).to appear_before(b_guest.email)

    click_link 'Email'
    expect(b_guest.email).to appear_before(a_guest.email)
  end

  scenario 'Admin sorts guests by phone' do
    click_link 'Phone'
    expect(a_guest.phone).to appear_before(b_guest.phone)

    click_link 'Phone'
    expect(b_guest.phone).to appear_before(a_guest.phone)
  end

  scenario 'Admin sorts guests by invited' do
    Fabricate(:invitation, guest: b_guest)
    visit admin_path

    click_link 'Invited'
    expect(a_guest.first_name).to appear_before(b_guest.first_name)

    click_link 'Invited'
    expect(b_guest.first_name).to appear_before(a_guest.first_name)
  end

  scenario 'Admin sorts guests by signed up at' do
    click_link 'Signed up at'
    expect(a_guest.first_name).to appear_before(b_guest.first_name)

    click_link 'Signed up at'
    expect(b_guest.first_name).to appear_before(a_guest.first_name)
  end

  scenario 'Admin sorts guests by invited at' do
    Fabricate(:invitation, guest: b_guest)
    visit admin_path

    expect(a_guest.first_name).to appear_before(b_guest.first_name)

    click_link 'Invited at'
    expect(b_guest.first_name).to appear_before(a_guest.first_name)

    # Uninvited guests will always show up at the bottom.
    click_link 'Invited at'
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
    expect(page.body).not_to include(c_guest.phone)
    expect(page.body).to include(a_guest.phone)
    expect(page.body).not_to include(b_guest.phone)


    click_link 'Plus one / Leader'
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
