class Invitation < ActiveRecord::Base
  belongs_to :guest

  before_create :generate_token
  after_commit :set_guest_invited_boolean, :send_invite

  def fulfill
    # Avoid calling after_commit callbacks again.
    self.update_column(:fulfilled, true)
    self.update_column(:token, nil)
    send_thanks
  end

  def fulfilled?
    self.fulfilled
  end

  private

  def generate_token
    self.token = SecureRandom.urlsafe_base64
  end

  def set_guest_invited_boolean
    self.guest.invited = true
    self.guest.save
  end

  def send_invite
    SendInviteJob.perform_async(self.guest.id)
  end

  def send_thanks
    SendThanksJob.perform_async(self.guest.id)
  end
end
