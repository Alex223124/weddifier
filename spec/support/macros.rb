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
