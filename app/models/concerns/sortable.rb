module Sortable
  extend ActiveSupport::Concern

  class_methods do
    def default_order
      Guest.all.order(invited: :asc).order(created_at: :desc).includes(:leader)
    end

    def order_by_invited_at(order)
      Guest.order(invited: :desc).order("invitations.created_at #{order}")
      .includes(:leader)
    end

    def order_by_relationship(order)
      if order == 'asc'
        Guest.joins(:plus_one).order(invited: :asc).order(created_at: :desc)
      elsif order == 'desc'
        Guest.where(leader_id: nil).where(plus_one_id: nil)
          .order(invited: :asc).order(created_at: :desc)
      end
    end

    def order_by_invited(order)
      Guest.order(invited: order.to_sym)
        .order("invitations.fulfilled IS TRUE desc").includes(:leader)
    end

    def order_by(query, order)
      Guest.order("#{query} #{order}").includes(:leader)
    end
  end
end
