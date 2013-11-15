class RelationshipsController < ApplicationController
  before_filter :signed_in_user
  respond_to :js

  def create
    if params[:user_share]
      @users = User.where(id: params[:user_share])
    else
      @users = Rails.env.development? ? User.where("id LIKE ?", "#{params[:users]}") : User.where("id ILIKE ?", "#{params[:users]}")
    end
    @users.each do |u|
      current_user.share!(u)
    end
    @pals = (current_user.sharers + current_user.sharees).uniq
    respond_with(@pals, @users)
  end

  def destroy
    @pals = (current_user.sharers + current_user.sharees).uniq
    @user = Relationship.find(params[:id]).sharee
    current_user.unshare!(@user)
    respond_with(@pals, @user)
  end
    
end
