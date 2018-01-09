require 'rails_helper'

describe Guest, type: :model do
  it { should have_one(:plus_one).class_name('Guest') }
  it { should have_one(:plus_one).with_foreign_key('leader_id') }
  it { should have_one :invitation }
  it { should belong_to(:leader).class_name('Guest') }
  # it { should belong_to(:leader).optional }
  it { should validate_presence_of :first_name }
  it { should allow_value('', nil).for(:last_name) }
  it { should validate_presence_of :father_surname }
  it { should validate_presence_of :mother_surname }
  it { should validate_presence_of :email }
  it { should validate_presence_of :phone }
  it { should validate_numericality_of :phone }
  it { should validate_length_of(:phone).is_at_least(10) }
  it { should validate_length_of(:phone).is_at_most(10) }
  it { should validate_uniqueness_of :email }

  context '#invited' do
    it 'returns true if invitation is present' do
      invitation = Fabricate(:invitation)
      guest = invitation.guest
      expect(guest.invited?).to be(true)
    end

    it 'returns false if invitation is not present' do
      guest = Fabricate(:guest)
      expect(guest.invited?).to be(false)
    end
  end

  context '#full_search' do
    let!(:guest) { Fabricate(:guest) }

    it 'searches by first name' do
      expect(Guest.full_search(guest.first_name[0, 2].downcase))
        .to include(guest)
    end

    it 'searches by last name' do
      expect(Guest.full_search(guest.last_name[0, 2].downcase))
        .to include(guest)
    end

    it 'searches by father surname' do
      expect(Guest.full_search(guest.father_surname[0, 2].downcase))
        .to include(guest)
    end

    it 'searches by mother surname' do
      expect(Guest.full_search(guest.mother_surname[0, 2].downcase))
        .to include(guest)
    end

    it 'searches by email' do
      expect(Guest.full_search(guest.email[0, 2].downcase))
        .to include(guest)
    end

    it 'searches by phone' do
      expect(Guest.full_search(guest.phone[0, 2].downcase))
        .to include(guest)
    end
  end
end
