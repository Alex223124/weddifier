require 'rails_helper'

feature 'Admin signs in' do
  scenario 'Admin visits admin path and logs in successfully' do
    admin = Fabricate(:admin)
    visit admin_path
    expect(page).to have_current_path(admin_login_path)

    fill_in 'Email', with: admin.email
    fill_in 'Password', with: admin.password
    click_on 'Login'

    expect(page).to have_current_path(admin_path)
    expect(page).to have_content('Welcome!')
  end
end
