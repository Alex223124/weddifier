module Admin
  class AdminsController < ApplicationController
    before_action :require_admin

    def index
      if params[:query] && params[:order]
        @sort = sort_status(params[:query], params[:order], params[:link])

        if params[:query] == 'invited_at'
          @guests = Guest.order(invited: :desc).order("invitations.created_at #{params[:order]}").includes(:leader)
        elsif params[:query] == 'relationship'
          if params[:order] == 'asc'
            @guests = Guest.joins(:plus_one).order(invited: :asc).order(created_at: :desc)
          elsif params[:order] == 'desc'
            @guests = Guest.where(leader_id: nil).where(plus_one_id: nil).order(invited: :asc).order(created_at: :desc)
          end
        else
          @guests = Guest.order("#{params[:query]} #{params[:order]}").includes(:leader)
        end
      else
        @sort = 'No sorts / filters'
        @guests = Guest.all.order(invited: :asc).order(created_at: :desc).includes(:leader)
      end
    end

    def search
      @guests = Guest.full_search(params[:search])
      render :index
    end

    private

    def sort_status(query, order, link_name)
      desc = (order == 'desc')

      if query == 'invited_at' || query == 'created_at'
        desc ? "#{link_name} Recent to Old" : "#{link_name} Old to Recent"
      elsif query == 'relationship'
        desc ? 'Guests without plus one' : 'Guests with plus one'
      else
        desc ? "#{link_name} Z-A / 9-0" : "#{link_name} A-Z / 0-9"
      end
    end
  end
end
