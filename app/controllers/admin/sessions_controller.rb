class Admin::SessionsController < ApplicationController
  def new
  end

  def create
    admin = Admin::Admin.find_by(email: params[:email])

    if admin && admin.authenticate(params[:password])
      session[:admin_id] = admin.id
      flash[:success] = 'Welcome!'
      redirect_to admin_path
    else
      flash[:error] = 'Invalid username and/or password.'
      render :new
    end
  end

  def destroy
    session[:admin_id] = nil
    redirect_to root_path
  end
end
