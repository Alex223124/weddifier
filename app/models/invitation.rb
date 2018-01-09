class Invitation < ActiveRecord::Base
  belongs_to :guest

  before_create :generate_token
  after_create :set_guest_invited_boolean

  private

  def generate_token
    self.token = SecureRandom.urlsafe_base64
  end

  def set_guest_invited_boolean
    self.guest.invited = true
    self.guest.save
  end
end
