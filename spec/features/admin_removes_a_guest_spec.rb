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

  scenario 'Removing a leader warns about deleting its plus one' do
    john.plus_one = dave
    john.save
    visit admin_path

    message = 'Deleting a leader will delete his plus one, are you sure you'\
      ' want to continue?'

    search_for('john')
    expect(page).to have_selector "a[data-confirm=\"#{message}\"]"
  end

  scenario 'Removing a plus one warns that you are deleting a leader\'s'\
    ' guest' do
      john.plus_one = dave
      john.save
      visit admin_path

      message = "You are deleting #{john.full_name}'s plus one. Are you sure"\
        ' you want to continue?'

      search_for('dave')
      expect(page).to have_selector("a[data-confirm=\"#{message}\"]")
  end
end
