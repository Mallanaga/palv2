class SessionsController < ApplicationController
  respond_to :html, :js

  def create
    user = User.find_by_email(params[:email].strip.downcase)
    if user && user.authenticate(params[:password])
      sign_in user
      flash[:success] = "Welcome back, #{user.first_name}"
      redirect_back_or root_url
    else
      flash[:error] = 'Invalid email/password credentials'
      redirect_back_or root_url
    end
  end

  def destroy
    sign_out
    flash[:notice] = 'See you soon!'
    redirect_to root_url
  end

  def new
    respond_with()
  end
end
