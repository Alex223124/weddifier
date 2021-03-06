class Guest < ActiveRecord::Base
  include Sortable
  PER_PAGE = 25

  default_scope { includes(:invitation).includes(:plus_one) }

  has_one :plus_one, class_name: 'Guest', foreign_key: 'leader_id',
    dependent: :destroy
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

  before_save :set_plus_one_id_on_leader, if: -> (guest) { guest.plus_one }

  def invited?
    self.invitation.present?
  end

  def self.full_search(query)
    self.where(
      "guests.first_name ILIKE ? OR guests.last_name ILIKE ? OR guests.father_surname ILIKE ? "\
      "OR guests.mother_surname ILIKE ? OR guests.email ILIKE ? OR guests.phone ILIKE ?",
      "%#{query}%", "%#{query}%", "%#{query}%",
      "%#{query}%", "%#{query}%", "%#{query}%"
    )
  end

  def full_name
    "#{first_name} #{last_name} #{father_surname} #{mother_surname}"
  end

  def leader?
    !self.plus_one_id.nil?
  end

  def plus_one?
    self.plus_one_id.nil? && !self.leader_id.nil?
  end

  def accepted_invitation?
    self.invitation.fulfilled?
  end

  private

  def set_plus_one_id_on_leader
    self.plus_one_id = plus_one.id
  end
end
