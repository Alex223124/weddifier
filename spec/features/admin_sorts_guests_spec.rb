require 'rails_helper'

feature 'Admin sorts guests' do
  let!(:a_guest) { Fabricate(:guest, first_name: 'A', last_name: 'A',
    father_surname: 'A', mother_surname: 'A', email: 'a@a.com',
    phone: 1111111111) }
  let!(:b_guest) { Fabricate(:guest, first_name: 'B', last_name: 'B',
    father_surname: 'B', mother_surname: 'B', email: 'b@b.com',
    phone: 2222222222) }

  background do
    admin_browser_login
  end

  scenario 'Admin sorts guests by first name and clears sorts' do
    click_link 'First name'
    expect(a_guest.first_name).to appear_before(b_guest.first_name)

    click_link 'First name'
    expect(b_guest.first_name).to appear_before(a_guest.first_name)

    click_button 'Clear filters'
    expect(a_guest.first_name).to appear_before(b_guest.first_name)
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
end
