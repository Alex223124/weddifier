require 'rails_helper'
require 'sucker_punch/testing/inline'
require 'capybara/email/rspec'

feature 'Guest registers and confirms invitation' do
  scenario 'Guest registers, receives email, opens it and confirms invite' do
    visit root_path
    fill_form_correctly
    guest = Guest.last
    Fabricate(:invitation, guest: guest)

    # Invitation email
    open_email(guest.email)
    current_email.click_link 'I am coming to the wedding!'
    expect(page).to have_content 'Your confirmation has been received!'

    # Thank you email
    open_email(guest.email)
    expect(current_email).to have_content "Thank you #{guest.first_name}, "\
      " for coming our wedding!"
  end
end
