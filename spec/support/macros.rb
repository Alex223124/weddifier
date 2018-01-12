def post_valid_guest_with_plus_one_option
  post guests_path, params: {
    guest: Fabricate.attributes_for(:guest).merge(plus_one: '1')}
  Guest.last
end

def post_valid_plus_one(leader)
  post guest_plus_one_index_path(
    plus_one: Fabricate.attributes_for(:guest), guest_id: leader.id)
  Guest.last.plus_one
end

def admin_login
  admin = Fabricate(:admin)
  post admin_login_path, params: { email: admin.email, password: admin.password }
end

def admin_browser_login
  admin = Fabricate(:admin)
  visit admin_login_path

  fill_in 'Email', with: admin.email
  fill_in 'Password', with: admin.password
  click_on 'Login'

  expect(page).to have_current_path(admin_path)
end

def expect_invite_button_to_be_present
  expect(page).to have_selector('a', text: /\bInvite\b/)
  expect(page).not_to have_selector('input[value="Invited"]')
end

def expect_invite_button_not_to_be_present
  expect(page).to have_selector('input[value="Invited"]')
  expect(page).not_to have_selector('a', text: /\bInvite\b/)
end

def expect_remove_button_to_be_present
  expect(page).to have_selector('a', text: /\bRemove\b/)
end

def expect_remove_button_not_to_be_present
  expect(page).not_to have_selector('a', text: /\bRemove\b/)
end

def search_for(guest_name)
  fill_in 'Search', with: guest_name
  click_on 'Search'
end
