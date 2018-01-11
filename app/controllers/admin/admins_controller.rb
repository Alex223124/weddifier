module Admin
  class AdminsController < ApplicationController
    before_action :require_admin

    def index
      if params[:query] && params[:order]
        if params[:query] == 'invited'
          @guests = Guest.unscoped.includes(:invitation).order("#{params[:query]} #{params[:order]}")
        elsif params[:query] == 'invited_at'
          @guests = Guest.unscoped.includes(:invitation).order("invited desc").order("invitations.created_at #{params[:order]}")
        else
          @guests = Guest.order("#{params[:query]} #{params[:order]}")
        end
      else
        @guests = Guest.all
      end
    end

    def search
      @guests = Guest.full_search(params[:search])
      render :index
    end
  end
end
