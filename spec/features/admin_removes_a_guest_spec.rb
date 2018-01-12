require 'rails_helper'

feature 'Guest removal' do
  let!(:john) { Fabricate(:guest, first_name: 'John') }
  let!(:dave) { Fabricate(:guest, first_name: 'Dave') }

  background do
    admin_browser_login
  end

  scenario 'Admin clicks on Remove for a guest with javascript', js: true do
    search_for('john')
    expect(page).to have_content(
      'Displaying  guests: Total: (1) - Invited: (0) - Remaining: (1)')

    click_on('Remove', match: :first)

    page.driver.browser.switch_to.alert.accept
    expect(page).not_to have_content john.phone
    expect(page).to have_content(
      'Displaying  guests: Total: (0) - Invited: (0) - Remaining: (0)')
  end

  scenario 'Admin clicks on Remove for a guest without javascript' do
    search_for('john')
    click_on('Remove', match: :first)
    expect(page).not_to have_content john.phone
  end
end
