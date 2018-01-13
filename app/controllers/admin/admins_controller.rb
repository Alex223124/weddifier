module Admin
  class AdminsController < ApplicationController
    before_action :require_admin

    def index
      if params[:query] && params[:order]
        if params[:query] == 'invited'
          @guests = Guest.order("invited #{params[:order]}")
        elsif params[:query] == 'invited_at'
          @guests = Guest.order(invited: :desc).order("invitations.created_at #{params[:order]}")
        elsif params[:query] == 'relationship'
          @guests = Guest.order("-id #{params[:order]}")
        else
          @guests = Guest.order("#{params[:query]} #{params[:order]}")
        end
      else
        @guests = Guest.all.order(invited: :asc)
      end
    end

    def search
      @guests = Guest.full_search(params[:search])
      render :index
    end
  end
end
