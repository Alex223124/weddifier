module Admin
  class AdminsController < ApplicationController
    before_action :require_admin

    def index
      if params[:query] && params[:order]
        if params[:query] == 'invited_at'
          @guests = Guest.order(invited: :desc).order("invitations.created_at #{params[:order]}").includes(:leader)
        elsif params[:query] == 'relationship'
          if params[:order] == 'asc'
            @guests = Guest.joins(:plus_one).order(created_at: :desc)
          elsif params[:order] == 'desc'
            @guests = Guest.where(leader_id: nil).where(plus_one_id: nil).order(created_at: :desc)
          end
        else
          @guests = Guest.order("#{params[:query]} #{params[:order]}").includes(:leader)
        end
      else
        @guests = Guest.all.order(invited: :asc).order(created_at: :desc).includes(:leader)
      end
    end

    def search
      @guests = Guest.full_search(params[:search])
      render :index
    end
  end
end
