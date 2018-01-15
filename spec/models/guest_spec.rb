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

  context '#set_plus_one_id_on_leader' do
    it 'sets the plus_one_id attribute on the leader when updated' do
      leader = Fabricate(:guest)
      plus_one = Fabricate(:guest)

      expect(leader.plus_one_id).to be_nil
      leader.plus_one = plus_one
      leader.save
      expect(leader.reload.plus_one_id).to eq(plus_one.id)
    end

    it 'changes the plus_one_id attribute when plus one is changed' do
      leader = Fabricate(:guest)
      plus_one = Fabricate(:guest)
      another_one = Fabricate(:guest)

      leader.plus_one = plus_one
      leader.save

      leader.plus_one = another_one
      leader.save

      expect(leader.reload.plus_one_id).to eq(another_one.id)
    end

    it 'only changes the plus_one_id attribute when there is a plus one' do
      leader = Fabricate(:guest)
      leader.first_name = 'Updated'
      leader.save

      expect(leader.plus_one_id).to be_nil
    end

    it 'changes the plus_one_id attribute on create too' do
      plus_one = Fabricate(:guest)
      leader = Fabricate(:guest, plus_one: plus_one)

      expect(leader.plus_one_id).to eq(plus_one.id)
    end
  end
end
