require 'rails_helper'
require 'sucker_punch/testing/inline'

describe 'Admin::Admins controller request', type: :request do
  context 'when admin is not logged in' do
    context 'GET index' do
      it 'redirects to admin login path' do
        get admin_path
        expect(response).to redirect_to admin_login_path
      end
    end

    context 'POST update' do
      it 'redirects to admin login path' do
        post admin_update_guests_path
        expect(response).to redirect_to admin_login_path
      end
    end
  end

  context 'when admin is logged in' do
    def admin_login
      admin = Fabricate(:admin)
      post admin_login_path, params: { email: admin.email, password: admin.password }
    end

    before { admin_login }

    context 'GET index' do
      it 'shows all guests' do
        guest1 = Fabricate(:guest)
        guest2 = Fabricate(:guest)
        get admin_path
        expect(response.body).to include(guest1.first_name)
        expect(response.body).to include(guest2.first_name)
      end
    end

    context 'POST update' do
      it 'invites selected guests' do
        guest1 = Fabricate(:guest)
        guest2 = Fabricate(:guest)
        expect(guest1.invited?).to eq(false)
        expect(guest2.invited?).to eq(false)
        post admin_update_guests_path(guest_ids: [guest1.id, guest2.id])
        expect(guest1.reload.invited?).to eq(true)
        expect(guest2.reload.invited?).to eq(true)
      end

      it 'displays a success message' do
        expect(flash[:success]).to be_present
      end

      it 'redirects to admin path' do
        expect(response).to redirect_to admin_path
      end

      it 'does not invite already invited guests' do
        guest1 = Fabricate(:invitation).guest
        guest2 = Fabricate(:invitation).guest
        expect(guest1.invited?).to eq(true)
        expect(guest2.invited?).to eq(true)
        expect {
          post admin_update_guests_path(guest_ids: [guest1.id, guest2.id])
        }.to change(Invitation, :count).by(0)
      end

      it 'sends emails to invited guests' do
        guest1 = Fabricate(:guest)
        guest2 = Fabricate(:guest)
        post admin_update_guests_path(guest_ids: [guest1.id, guest2.id])
        expect(ActionMailer::Base.deliveries.map(&:to).flatten.first)
          .to include(guest1.email)
        expect(ActionMailer::Base.deliveries.map(&:to).flatten.last)
          .to include(guest2.email)
      end
    end
  end
end
