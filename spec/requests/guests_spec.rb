require 'rails_helper'

describe 'Guests Controller request', type: :request do
  context 'GET index' do
    context 'if guest has already registered (id in session)' do
      it 'redirects to home' do
        post guests_path, params: { guest: Fabricate.attributes_for(:guest) }
        get new_guest_path
        expect(response).to redirect_to home_path
      end
    end

    it 'displays a form for guests to register' do
      get new_guest_path
      expect(response.body).to include('<form')
    end
  end

  context 'POST create' do
    context 'with invalid inputs' do
      before { post guests_path, params: { guest: { first_name: '' } } }

      it 'does not set a session' do
        expect(session[:guest_id]).to be_nil
      end

      it 're-renders form' do
        expect(response.body).to include('<form')
      end

      it 'displays a flash error message' do
        expect(flash[:error]).to be_present
      end

      it 'displays what fields have errors' do
        expect(response.body).to include(CGI::escapeHTML("can't be blank"))
      end

      it 'does not create a guest' do
        expect {
          post guests_path, params: { guest: { first_name: '' } }
        }.to change(Guest, :count).by(0)
      end
    end

    context 'with valid inputs' do
      def post_valid_guest
        post guests_path, params: { guest: Fabricate.attributes_for(:guest) }
      end

      it 'sets the session to the guest id' do
        post_valid_guest
        expect(session[:guest_id]).not_to be_nil
        expect(session[:guest_id]).to eq(Guest.last.id)
      end

      it 'redirects to thank you page' do
        post_valid_guest
        expect(response).to redirect_to thank_you_path
      end

      it 'displays a flash success message' do
        post_valid_guest
        expect(flash[:success]).to be_present
      end

      it 'creates a guest' do
        expect {
          post_valid_guest
          attributes = Fabricate.attributes_for(:guest)
          post guests_path, params: { guest: attributes }
        }.to change(Guest, :count).by(1)
      end
    end
  end
end