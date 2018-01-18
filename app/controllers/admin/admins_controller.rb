module Admin
  class AdminsController < ApplicationController
    before_action :require_admin

    def index
      query, order = [params[:query], params[:order]]

      if query && order
        @guests = case query
        when 'invited_at' then Guest.order_by_invited_at(order)
        when 'relationship' then  Guest.order_by_relationship(order)
        when 'invited' then Guest.order_by_invited(order)
        else Guest.order_by(query, order)
        end
      else
        @guests = Guest.default_order
      end
    end

    def search
      @guests = Guest.full_search(params[:search]).includes(:leader)
      render :index
    end
  end
end
