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
    let(:invitation) { Fabricate(:invitation) }

    # To avoid race conditions we don't actually "send" the email.
    before { allow(invitation).to receive(:send_invite) }

    after { ActionMailer::Base.deliveries.clear }

    it 'sets the invitation fulfilled attribute to true' do
      expect(invitation.fulfilled).to be false
      invitation.fulfill
      expect(invitation.fulfilled).to be true
    end

    it 'sets the token to nil' do
      expect(invitation.token).to be_present
      invitation.fulfill
      expect(invitation.token).not_to be_present
    end

    it 'saves itself' do
      expect_any_instance_of(Invitation).to receive(:save)
      invitation.fulfill
    end

    it 'sends thank you email' do
      invitation.fulfill
      expect(ActionMailer::Base.deliveries.size).to eq(2)
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
