require 'rails_helper'

describe Invitation, type: :model do
  it { should belong_to :guest }

  it 'generates secure random url safe token on creation' do
    allow(SecureRandom).to receive(:urlsafe_base64).and_return('123')
    guest = Fabricate(:guest)
    invitation = Invitation.create(guest: guest)
    expect(invitation.token).to eq('123')
  end
end
