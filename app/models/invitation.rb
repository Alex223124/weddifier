class Invitation < ActiveRecord::Base
  belongs_to :guest

  before_create :generate_token

  private

  def generate_token
    self.token = SecureRandom.urlsafe_base64
  end
end
