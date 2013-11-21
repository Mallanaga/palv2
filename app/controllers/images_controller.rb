class ImagesController < ApplicationController
  before_filter :correct_user,      only: [:update, :delete]
  respond_to :js

  def create
    @event = Event.find(params[:event_id])
    params[:image][:user_id] = current_user.id
    @image = @event.images.build(image_params)
    if @image.save
      @images = @event.images
      respond_with(@image, @images, @event)
    else
      flash[:error] = 'Invalid image'
    end

  end

  def destroy
    @image = Image.find(params[:id])
    @event = @image.event
    @image.update_attributes(event: nil)
    @images = @event.images
    respond_with(@event, @images)
  end

  def edit
    @image = Image.find(params[:id])
  end

  def index

  end

  def show
    @image = Image.find(params[:id])
  end

  def update
    @image = Image.find(params[:id])
    @event = Event.find(@image.event)
    if @image.update_attributes(image_params)
      redirect_to event_images_url(@event), notice: "Image was successfully updated."
    else
      render :edit
    end
  end

  def vote
    vote = current_user.image_votes.new(value: params[:value], image_id: params[:id])
    if vote.save
      redirect_to :back, notice: "Thank you for voting."
    else
      redirect_to :back, alert: "Unable to vote, perhaps you already did."
    end
  end

  private
  
    def correct_user
      @user = Image.find(params[:id]).user
      redirect_to(root_path) unless current_user?(@user)
    end

    def image_params
      params.require(:image).permit!
    end

end
