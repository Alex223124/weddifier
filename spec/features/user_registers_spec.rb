require 'rails_helper'

feature 'User registration' do
  scenario 'User visits root path and registers successfully' do
    expect(Guest.count).to eq(0)
    visit root_path
    fill_in 'First name' , with: 'John'
    fill_in 'Last name' , with: 'Doe'
    fill_in 'Father surname' , with: 'Mckenzie'
    fill_in 'Mother surname' , with: 'Sullivan'
    fill_in 'Phone' , with: '1234567890'
    fill_in 'Email' , with: 'example@email.com'
    click_on 'Register'
    expect(page).to have_current_path(thank_you_path)
    expect(Guest.count).to eq(1)
  end

  scenario 'User vists root path and registers unsuccessfully' do
    expect(Guest.count).to eq(0)
    visit root_path
    fill_in 'First name' , with: 'John'
    click_on 'Register'
    expect(page).to have_current_path(guests_path)
    expect(page).to have_content('There are some errors in your form.')
    expect(page).to have_content('Phone is too short')
    expect(Guest.count).to eq(0)
  end
end
