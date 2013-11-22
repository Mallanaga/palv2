class RelationshipsController < ApplicationController
  before_filter :signed_in_user
  respond_to :js

  def create
    @users = User.where(id: params[:users].split(','))
    @users.each do |u|
      current_user.share!(u)
      Relationship.find_by_sharee_id_and_sharer_id(u.id, current_user.id).create_activity :create, owner: current_user, recipient: u
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
