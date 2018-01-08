require 'rails_helper'

describe 'Admin::Admins controller request', type: :request do
  context 'when admin is not logged in' do
    it 'redirects to admin login path' do
      get admin_path
      expect(response).to redirect_to admin_login_path
    end
  end

  context 'when admin is logged in' do
    def admin_login
      admin = Fabricate(:admin)
      post admin_login_path, params: { email: admin.email, password: admin.password }
    end

    before { admin_login }

    it 'shows all guests' do
      guest1 = Fabricate(:guest)
      guest2 = Fabricate(:guest)
      get admin_path
      expect(response.body).to include(guest1.first_name)
      expect(response.body).to include(guest2.first_name)
    end
  end
end
