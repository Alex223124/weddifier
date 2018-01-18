module Admin
  class AdminsController < ApplicationController
    before_action :require_admin

    def index
      query, order = [params[:query], params[:order]]

      if query && order
        @sort = sort_status(query, order, params[:link])

        @guests = case query
        when 'invited_at' then Guest.order_by_invited_at(order)
        when 'relationship' then  Guest.order_by_relationship(order)
        when 'invited' then Guest.order_by_invited(order)
        else Guest.order_by(query, order)
        end

      else
        @sort = 'No sorts / filters'
        @guests = Guest.default_order
      end
    end

    def search
      @sort = 'No sorts / filters'
      @guests = Guest.full_search(params[:search]).includes(:leader)
      render :index
    end

    private

    def sort_status(query, order, link_name)
      desc = (order == 'desc')

      if query == 'invited_at' || query == 'created_at'
        desc ? "#{link_name}, Recent to Old" : "#{link_name}, Old to Recent"
      elsif query == 'relationship'
        desc ? 'Guests without plus one' : 'Guests with plus one'
      elsif query == 'invited'
        desc ? "#{link_name}, confirmed first" : "#{link_name}, non-invited first"
      else
        desc ? "#{link_name}, Z-A / 9-0" : "#{link_name}, A-Z / 0-9"
      end
    end
  end
end
