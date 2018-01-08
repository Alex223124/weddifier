class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def js_flash(message, type)
    {message: message, type: type }
  end
end
