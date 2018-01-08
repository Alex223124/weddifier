class SendInviteJob
  include SuckerPunch::Job

  def perform(guest_id)
    ActiveRecord::Base.connection_pool.with_connection do
      @guest = Guest.find guest_id
      ApplicationMailer.send_invite(@guest.id).deliver
    end
  end
end
