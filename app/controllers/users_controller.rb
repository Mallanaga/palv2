class UsersController < ApplicationController
  include ActionView::Helpers::TextHelper
  respond_to :html, :js, :json

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      flash.now[:success] = "Welcome to Palendar, #{@user.first_name}"
      respond_with(@user)
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

  def find
    @users = User.where.not(id: current_user.id).order(:name)
    @users = Rails.env.development? ? @users.where("name like ?", "%#{params[:q]}%") : @users.where("name ilike ?", "%#{params[:q]}%")
    render json: @users
  end

  def history
    @events = current_user.attended_events.where('finish < ?', Date.current.beginning_of_day).reorder(start: :desc)
    @hash = Gmaps4rails.build_markers(@events) do |event, marker|
      marker.lat event.lat
      marker.lng event.lng
      marker.title "#{pluralize(event.attendees.size, 'person')} going"
      marker.infowindow render_to_string(partial: '/events/infobox', 
                                         locals: {object: event})
      marker.picture({
        anchor: [10,34],
        url: ActionController::Base.helpers.asset_path('purple_marker.png'),
        width: 20,
        height: 34 })
      marker.shadow({
        anchor: [2,22],
        url: ActionController::Base.helpers.asset_path('sprite_shadow.png'),
        width: 29,
        height: 22 })
    end
    respond_with(@events, @hash)
  end

  def index
    @pals = (current_user.sharers + current_user.sharees).uniq
    respond_with(@pals)
  end

  def invite
    @users = current_user.sharees
    @users = Rails.env.development? ? @users.where("name like ?", "%#{params[:q]}%") : @users.where("name ilike ?", "%#{params[:q]}%")
    render json: @users
  end

  def new
    @user = User.new
    respond_with(@user)
  end

  def notifications
    
  end

  def settings
    
  end

  def show
    @user = User.find(params[:id])
    @events = []
    if current_user?(@user)
      @events += @user.attended_events.where('finish >= ?', Date.current.beginning_of_day)
    else
      # public events of your pals
      @events += @user.attended_events.where('finish >= ?', Date.current.beginning_of_day)
                                     .where(:private => false)
      # private events of your pals where you were also invited
      @events += (@user.attended_events.where('finish >= ?', Date.current.beginning_of_day)
                  .where(:private => true) & 
                  current_user.invited_events.where('finish >= ?', Date.current.beginning_of_day)
                  .where(:private => true)
                 )   
    end
    @events.uniq!
    @hash = Gmaps4rails.build_markers(@events) do |event, marker|
      marker.lat event.lat
      marker.lng event.lng
      marker.title "#{pluralize(event.attendees.size, 'person')} going"
      marker.infowindow render_to_string(partial: '/events/infobox', 
                                         locals: {object: event})
      marker.picture({
        anchor: [10,34],
        url: ActionController::Base.helpers.asset_path('purple_marker.png'),
        width: 20,
        height: 34 })
      marker.shadow({
        anchor: [2,22],
        url: ActionController::Base.helpers.asset_path('sprite_shadow.png'),
        width: 29,
        height: 22 })
    end
    respond_with(@events, @hash, @user)
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
          :lat, :lng, :location
        )
      end
    end
end
