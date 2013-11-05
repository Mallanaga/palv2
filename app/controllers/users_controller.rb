class UsersController < ApplicationController
  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      flash[:success] = 'User created'
      redirect_back_or root_url
    else
      render 'users/new'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = 'User destroyed'
  end

  def edit
    @user = User.find(params[:id])
  end

  def index
  end

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = 'User updated'
      sign_in current_user
    else
      flash[:error] = 'Invalid User parameters'
    end 
  end

  private
    def user_params
      if admin?
        params.require(:user).permit!
      else
        params.require(:user).permit(
        :name, :email, :gender, :dob, :password,
        :lat, :lng
      )
      end
    end
end
