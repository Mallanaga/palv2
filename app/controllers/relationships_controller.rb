class RelationshipsController < ApplicationController
  before_filter :signed_in_user
  respond_to :js

  def create
    @users = User.where(id: params[:users].split(','))

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
