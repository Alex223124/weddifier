require 'rails_helper'
require 'sucker_punch/testing/inline'

describe Invitation, type: :model do
  it { should belong_to :guest }
  it { should callback(:generate_token).before(:create) }
  it { should callback(:set_guest_invited_boolean).after(:commit) }
  it { should callback(:send_invite).after(:commit) }

  context 'After committing the Invitation to the database' do
    let(:guest) { Fabricate(:guest) }

    after { ActionMailer::Base.deliveries.clear }

    it 'generates secure random url safe token' do
      allow(SecureRandom).to receive(:urlsafe_base64).and_return('123')
      invitation = Invitation.create(guest: guest)
      expect(Invitation.all.size).to eq(1)
      expect(invitation.token).to eq('123')
    end

    it 'sends an invite email' do
      Fabricate(:invitation, guest: guest)
      expect(Invitation.all.size).to eq(1)
      expect(ActionMailer::Base.deliveries.last.to).to eq([guest.email])
    end
  end

  context '#fulfill' do
    # Use let! to trigger :send_invite email and clear it because we are not
    # testing that callback now.
    let!(:invitation) { Fabricate(:invitation) }

    # Clear :send_invite email.
    before { ActionMailer::Base.deliveries.clear }
    # Clear :send_thanks email.
    after { ActionMailer::Base.deliveries.clear }

    it 'sets the invitation fulfilled attribute to true' do
      expect(invitation.fulfilled).to be false
      invitation.fulfill
      expect(invitation.reload.fulfilled).to be true
    end

    it 'sets the token to nil' do
      expect(invitation.token).to be_present
      invitation.fulfill
      expect(invitation.reload.token).not_to be_present
    end

    it 'sends thank you email' do
      invitation.fulfill
      # Thank you email (fulfillment) only.
      expect(ActionMailer::Base.deliveries.size).to eq(1)
    end
  end

  context '#fulfilled?' do
    it 'returns the fulfilled boolean attribute' do
      invitation = Fabricate(:invitation)
      invitation.fulfilled = true
      invitation.save
      expect(invitation.reload.fulfilled?).to be true
    end
  end
end
