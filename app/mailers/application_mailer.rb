class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'

  def send_invite(guest_id)
    @guest = Guest.find guest_id
    mail to: @guest.email, subject: 'You are invited to the wedding!'
  end

  def send_thanks(guest_id)
    @guest = Guest.find guest_id
    mail to: @guest.email, subject: 'Thank you for coming!'
  end
end
