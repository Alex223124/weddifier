require 'rails_helper'

describe 'Admin::Sessions controller request', type: :request do
  context 'GET new' do
    it 'displays a login form' do
      get admin_login_path
      expect(response.body).to include('<form')
    end
  end

  context 'POST create' do
    context 'with valid inputs' do
      let(:admin) { Fabricate(:admin) }

      before do
        post admin_login_path, params:
          { email: admin.email, password: admin.password }
      end

      it 'sets the session to admin id' do
        expect(session[:admin_id]).to eq(admin.id)
      end

      it 'redirects to admin index' do
        expect(response).to redirect_to admin_path
      end

      it 'display a flash success error' do
        expect(flash[:success]).to be_present
      end
    end

    context 'with invalid inputs' do
      let(:admin) { Fabricate(:admin) }

      before do
        post admin_login_path, params:
          { email: admin.email, password: '' }
      end

      it 'renders form again' do
        expect(response.body).to include('<form')
      end

      it 'form retains entered email' do
        expect(response.body).to include(admin.email)
      end

      it 'displays a flash error' do
        expect(flash[:error]).to be_present
      end
    end
  end

  context 'GET destroy' do
    before { get admin_logout_path }

    it 'sets the session for admin to nil' do
      expect(session[:admin_id]).to be_nil
    end

    it 'redirects to root path' do
      expect(response).to redirect_to root_path
    end
  end
end
