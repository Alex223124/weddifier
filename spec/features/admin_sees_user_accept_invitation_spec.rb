require 'rails_helper'

feature 'Admin sees user accept invitation' do
  background do
    admin_browser_login
  end

  scenario 'Counters should reflect confirmed guests' do
    guest = Fabricate(:guest)
    visit admin_path
    expect(page).to have_content('Remaining: (1) - Confirmed: (0)')

    invitation = Fabricate(:invitation, guest: guest)
    invitation.fulfill

    visit admin_path
    expect(page).to have_content('Remaining: (0) - Confirmed: (1)')
  end

  scenario 'Invite button should reflect confirmed guest' do
    guest = Fabricate(:guest)
    visit admin_path
    expect(page).to have_content(/\bInvite\b/)

    invitation = Fabricate(:invitation, guest: guest)
    invitation.fulfill

    visit admin_path
    expect(page).to have_selector('button#confirmed-button')
  end
end
