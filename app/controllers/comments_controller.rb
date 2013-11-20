class CommentsController < ApplicationController
  respond_to :js
  
  def create
    @event = Event.find(params[:comment][:event_id])
    params[:comment][:user_id] = current_user.id
    @comment = Comment.new(comment_params)
    if @comment.save
      respond_with(@event, @comment)
    else
      render 'events/show'
    end
  end

  private
    def comment_params
      params.require(:comment).permit!
    end

end
