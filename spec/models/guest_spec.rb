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
end

class Guest < ActiveRecord::Base
  has_one :plus_one, class_name: 'Guest', foreign_key: 'leader_id'
  belongs_to :leader, class_name: 'Guest', optional: true
  # Optional is true because a Guest does not always needs a leader, it can
  # either be a leader himself, or be a plus one and indeed need a leader.

  has_one :invitation

  validates_presence_of :first_name, :father_surname, :mother_surname, :email,
    :phone
  validates_presence_of :last_name, allow_blank: true
  validates_numericality_of :phone
  validates_length_of :phone, { minimum: 10, maximum: 10 }
  validates_uniqueness_of :email

  def invited?
    self.invitation.present?
  end
end
