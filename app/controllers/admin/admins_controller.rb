module Admin
  class AdminsController < ApplicationController
    before_action :require_admin

    def index
      if params[:query] && params[:order]
        if params[:query] == 'invited'
          @guests = Guest.unscoped.order("#{params[:query]} #{params[:order]}")
        else
          @guests = Guest.order("#{params[:query]} #{params[:order]}")
        end
      else
        @guests = Guest.all
      end
    end

    def update
      ActiveRecord::Base.transaction do
        params[:guest_ids].each do |guest_id|
          guest = Guest.find guest_id

          next if guest.invited?

          Invitation.create!(guest: guest)
        end
      end

      flash[:success] = 'Guests invited successfully.'
      redirect_to admin_path
    end

    private

    def require_admin
      redirect_to admin_login_path unless admin_logged_in?
    end

    def admin_logged_in?
      !!session[:admin_id].present?
    end
  end
end
