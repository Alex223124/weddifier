require 'rails_helper'

describe 'Guests Controller request', type: :request do
  context 'GET new' do
    context 'if guest has already registered (id in session)' do
      it 'can visit root path again' do
        post guests_path, params: { guest: Fabricate.attributes_for(:guest) }
        get new_guest_path
        expect(response.status).to be(200)
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
        expect(flash[:danger]).to be_present
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

      context 'when already registered' do
        before { post_valid_guest }

        it_behaves_like 'trying to register twice' do
          let(:action) { post_valid_guest }
        end
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

      context 'and registering a plus one' do
        it 'redirects to new plus one path' do
          new_guest = post_valid_guest_with_plus_one_option
          expect(response).to redirect_to new_guest_plus_one_path(new_guest.id)
        end
      end
    end
  end

  context 'DELETE destroy' do
    context 'when no admin logged in' do
      it 'redirects to admin login path' do
        delete guest_path(Fabricate(:guest))
        expect(response).to redirect_to admin_login_path
      end
    end

    context 'when admin logged in' do
      before { admin_login }

      context 'with valid guest' do
        let!(:guest) { Fabricate(:guest) }

        it 'destroys the guest' do
          expect { delete guest_path(guest) }.to change(Guest, :count).by(-1)
        end

        it 'redirects to admin path' do
          delete guest_path(guest)
          expect(response).to redirect_to admin_path
        end

        it 'displays a flash success message' do
          delete guest_path(guest)
          expect(flash[:success]).to be_present
        end

        it 'if leader was deleted, flash that plus one was deleted' do
          plus_one = Fabricate(:guest)
          guest.plus_one = plus_one
          guest.save
          message = "Successfully removed guest #{guest.full_name} -"\
            " #{guest.email}. Also deleted plus one: #{plus_one.full_name}"\
            " - #{plus_one.email}."

          delete guest_path(guest)
          expect(flash[:success]).to eq(message)
        end

        it 'if plus one was deleted, flash that leader is now left without plus'\
          ' one' do
          plus_one = Fabricate(:guest)
          guest.plus_one = plus_one
          guest.save
          message = "Successfully removed guest #{plus_one.full_name} -"\
            " #{plus_one.email}. #{guest.full_name} has no plus one now."

          delete guest_path(plus_one)
          expect(flash[:success]).to eq(message)
        end
      end

      context 'with invalid guest' do
        before { delete guest_path(1) }

        it 'flashes an error message' do
          expect(flash[:danger]).to be_present
        end

        it 'redirects to admin path' do
          expect(response).to redirect_to admin_path
        end
      end
    end
  end
end
