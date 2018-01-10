require 'rails_helper'
require 'sucker_punch/testing/inline'

describe 'Invitations Controller request', type: :request do
  context 'POST create' do
    context 'when logged out' do
      it_behaves_like 'a logged out admin' do
        let(:action) { post guest_invitations_path(1) }
      end
    end

    context 'when logged in' do
      before { admin_login }

      context 'when guest has no invitation' do
        let!(:guest) { Fabricate(:guest) }

        before { post guest_invitations_path(guest) }
        after { ActionMailer::Base.deliveries.clear }

        it 'creates an invitation for the given guest' do
          expect(guest.reload.invitation).not_to be_nil
        end

        it 'sets the guest invited boolean to true' do
          expect(guest.reload.invited).to be(true)
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
          expect(flash[:danger]).to be_present
        end
    end
    end
  end

  context 'POST bulk_create' do
    context 'when logged out' do
      it_behaves_like 'a logged out admin' do
        let(:action) { post admin_update_guests_path }
      end
    end

    context 'when logged in' do
      before { admin_login }

      context 'if no guests were selected' do
        it 'redirects to admin path if no guest ids where passed' do
          post admin_update_guests_path
          expect(response).to redirect_to admin_path
        end

        it 'flashes a warning' do
          post admin_update_guests_path
          expect(flash[:warning]).to be_present
        end
      end

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
