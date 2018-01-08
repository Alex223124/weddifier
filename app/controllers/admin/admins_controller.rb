class Admin::AdminsController < ApplicationController
  before_action :require_admin

  def index
    @guests = Guest.all
  end

  private

  def require_admin
    redirect_to admin_login_path unless admin_logged_in?
  end

  def admin_logged_in?
    !!session[:admin_id].present?
  end
end
