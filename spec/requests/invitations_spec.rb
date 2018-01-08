require 'rails_helper'
require 'sucker_punch/testing/inline'

describe 'Invitations Controller request', type: :request do
  context 'POST create' do
    context 'when guest has no invitation' do
      let!(:guest) { Fabricate(:guest) }

      before { post guest_invitations_path(guest) }
      after { ActionMailer::Base.deliveries.clear }

      it 'creates an invitation for the given guest' do
        expect(guest.reload.invitation).not_to be_nil
      end

      it 'displays a flash success message' do
        expect(flash[:success]).to be_present
      end

      it 'redirects to admin path' do
        expect(response).to redirect_to admin_path
      end

      it 'sends an email to the invited guest' do
        expect(ActionMailer::Base.deliveries.last.to).to eq([guest.email])
      end
    end

    context 'when guest has an invitation already' do
      let!(:invitation) { Fabricate(:invitation) }

      it 'does not create another invitation for the given guest' do
        expect { post guest_invitations_path(invitation.guest) }.to change(
          Invitation, :count).by(0)
      end

      it 'redirects to admin path' do
        post guest_invitations_path(invitation.guest)
        expect(response).to redirect_to admin_path
      end

      it 'flashes an error message' do
        post guest_invitations_path(invitation.guest)
        expect(flash[:error]).to be_present
      end
    end
  end
end
