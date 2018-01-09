class Admin::AdminsController < ApplicationController
  before_action :require_admin

  def index
    if params[:query] && params[:order]
      @guests = Guest.order("#{params[:query]} #{params[:order]}")
    else
      @guests = Guest.all
    end
  end

  private

  def require_admin
    redirect_to admin_login_path unless admin_logged_in?
  end

  def admin_logged_in?
    !!session[:admin_id].present?
  end
end
