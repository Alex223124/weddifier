class PagesController < ApplicationController
  def home
    session[:guest_id] = nil
    session[:plus_one_id] = nil
  end

  def thanks
  end
end
