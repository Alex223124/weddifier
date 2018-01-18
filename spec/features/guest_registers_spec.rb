require 'rails_helper'

feature 'User registration' do
  scenario 'User visits root path and registers successfully' do
    expect(Guest.count).to eq(0)
    visit root_path
    fill_form_correctly
    expect(page).to have_current_path(thank_you_path)
    expect(Guest.count).to eq(1)
  end

  scenario 'User registers successfully and tries to register again' do
    visit root_path
    fill_form_correctly
    visit root_path
    expect(page).to have_current_path(root_path)
  end

  scenario 'User vists root path and registers unsuccessfully' do
    expect(Guest.count).to eq(0)
    visit root_path
    fill_form_incorrectly
    expect(page).to have_current_path(guests_path)
    expect(page).to have_content('There are some errors in your form.')
    expect(page).to have_content('Phone is too short')
    expect(Guest.count).to eq(0)
  end
end
