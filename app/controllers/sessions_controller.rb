class SessionsController < ApplicationController
  respond_to :html, :js

  def create
    user = User.find_by_email(params[:email].strip.downcase)
    if user && user.authenticate(params[:password])
      sign_in user
      flash[:success] = "Welcome back, #{user.first_name}"
      respond_with()
    else
      flash.now[:error] = 'Invalid email/password combination'
      render 'sessions/new'
    end
  end

  def destroy
    sign_out
    flash[:notice] = 'Logged out successfully'
    respond_with()
  end

  def new
    respond_with()
  end

end
