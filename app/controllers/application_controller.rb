class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def js_flash(message, type)
    {message: message, type: type }
  end

  def require_admin
    redirect_to admin_login_path unless admin_logged_in?
  end

  def admin_logged_in?
    !!session[:admin_id].present?
  end
end
