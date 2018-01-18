require 'rails_helper'
include ActionView::Helpers::DateHelper

feature 'Admin search' do
  let!(:john) { Fabricate(:guest, first_name: 'John') }
  let!(:dave) { Fabricate(:guest, first_name: 'Dave') }

  background do
    # Needs windows running chromedriver
    # This sets Capybara up to use a REMOTE Selenium server
    # Capybara.javascript_driver = :selenium_remote_chrome
    # Capybara.register_driver "selenium_remote_chrome".to_sym do |app|
     # Capybara::Selenium::Driver.new(app, browser: :remote, url: "http://localhost:9515", desired_capabilities: :chrome)
    # end

    # Does not support ES6
    # Capybara.javascript_driver = :poltergeist
    # Capybara.register_driver :poltergeist do |app|
    #   Capybara::Poltergeist::Driver.new(app, window_size: [2000, 2000])
    # end

    # Works but get a weird RSpec formatting error
    # Capybara.javascript_driver = :selenium_chrome_headless

    # Can not connect
    # Capybara.javascript_driver = :webkit

    # Capybara.register_driver :chrome do |app|
    #   Capybara::Selenium::Driver.new app, browser: :chrome,
    #     options: Selenium::WebDriver::Chrome::Options.new(args: %w[headless disable-gpu])
    # end

    # Capybara.javascript_driver = :chrome

    admin_browser_login
  end

  scenario 'Admin searches for a guest' do
    expect(page).to have_content('John')
    expect(page).to have_content('Dave')
    expect(page).to have_content(
      'Displaying  guests: Total: (2) - Invited: (0) - Remaining: (2)')

    search_for('john')

    expect(page).to have_content('John')
    expect(page).not_to have_content('Dave')
    expect(page).to have_content(
      'Displaying  guests: Total: (2) - Invited: (0) - Remaining: (2)')
  end

  scenario 'Admin searches for a guest and single invites from search results', js: true do
    expect_invite_button_to_be_present
    expect_remove_button_to_be_present

    search_for('john')
    click_on('Invite')

    expect(page).to have_content('Successfully invited guest John')
    expect_invite_button_not_to_be_present
    expect_remove_button_not_to_be_present
    expect(page).to have_content(format_date(john.invitation.created_at))
  end

  scenario 'Admin searches for a guest and bulk invites from search results', js: true do
    expect_invite_button_to_be_present
    expect_remove_button_to_be_present

    search_for('john')
    find(:css, "#select_all").set true
    find('button#bulk-invite-button', match: :first).click

    expect(page).to have_content('Guests invited successfully.')
    expect_invite_button_not_to_be_present
    expect_remove_button_not_to_be_present
    expect(page).to have_content(format_date(john.invitation.created_at))
  end

  scenario 'Admin searches and sorting by status should reflect no sorts' do
    search_for('john')
    expect(page).to have_content('Sorting by: No sorts / filters')
  end

  def format_date(date)
    time_ago_in_words(date.in_time_zone('America/Mexico_City'),
      include_seconds: true) + ' ago' + ' / ' +
      date.in_time_zone('America/Mexico_City').strftime("%A %d %b %l:%M%P")
  end
end
