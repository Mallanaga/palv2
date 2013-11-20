class EventsController < ApplicationController
  include ActionView::Helpers::TextHelper
  require 'open-uri'

  before_filter :admin_user,     only: [:destroy]
  before_filter :correct_user,   only: [:edit, :update]
  before_filter :signed_in_user, only: [:create, :destroy, :edit, :new, :update]
  respond_to :html, :js

  def create
    Time.zone = Time.zone = JSON.load(open("https://maps.googleapis.com/maps/api/timezone/json?location=#{params[:event][:lat]},#{params[:event][:lng]}&timestamp=1331161200&sensor=false"))["timeZoneId"]
    params[:event][:user_id] = current_user.id
    params[:event][:start] = params[:event][:start].to_date
    params[:event][:finish] = params[:event][:finish].to_date
    params[:event][:finish] = params[:event][:start].to_date if params[:event][:finish].blank?
    @event = current_user.events.build(event_params)
    if @event.save
      if @event.private?
        current_user.invite!(@event)
        params[:invited].split(',').each do |id|
          User.find(id).invite!(@event)
        end
      end
      current_user.attend!(@event)
      flash.now[:success] = "'#{@event.name}' created"
      respond_with(@event)
    else
      render 'events/new'
    end
    
  end

  def destroy
    Event.find(params[:id]).destroy
    flash[:notice] = 'Event destroyed'
  end

  def edit
    @event = Event.find(params[:id])
  end

  def find
    date = params[:date].to_date
    range = signed_in? ? current_user.range : 10
    days_events = Event.where("start <= ? AND finish >= ?", date.end_of_day,
                              date.beginning_of_day).where(:private => false)
    @events = days_events.locals(params[:lat], params[:lng], range)
    @hash = Gmaps4rails.build_markers(@events) do |event, marker|
      marker.lat event.lat
      marker.lng event.lng
      marker.title "#{pluralize(event.attendees.size, 'person')} going"
      marker.infowindow render_to_string(partial: '/events/infobox', 
                                         locals: {object: event})
    end
    respond_with(@events, @hash)
  end

  def index
    @events = []
  end

  def new
    @event = Event.new
    respond_with(@event)
  end

  def pals
    @events = []
    current_user.sharers.each do |u|
      # public events of your pals
      @events += u.attended_events.where('finish > ?', Date.today.beginning_of_day)
                                  .where(:private => false)
      # private events of your pals where you were also invited
      @events += (u.attended_events.where('finish > ?', Date.today.beginning_of_day)
                  .where(:private => true) & 
                  current_user.invited_events.where('finish > ?', Date.today.beginning_of_day)
                  .where(:private => true)
                 )                  
    end
    @events.uniq!
    @events.each do |e|
      @events.delete(e) if (current_user.invited?(e) && !current_user.attending?(e))
    end
    @hash = Gmaps4rails.build_markers(@events) do |event, marker|
      marker.lat event.lat
      marker.lng event.lng
      marker.title "#{pluralize(event.attendees.size, 'person')} going"
      marker.infowindow render_to_string(partial: '/events/infobox', 
                                         locals: {object: event})
      marker.picture({
        anchor: [10,34],
        url: ActionController::Base.helpers.asset_path('lime_marker.png'),
        width: 20,
        height: 34 })
      marker.shadow({
        anchor: [2,22],
        url: ActionController::Base.helpers.asset_path('sprite_shadow.png'),
        width: 29,
        height: 22 })
    end
    @events += (current_user.invited_events - current_user.attended_events)
    @hash += Gmaps4rails.build_markers(current_user.invited_events - current_user.attended_events) do |event, marker|
      marker.lat event.lat
      marker.lng event.lng
      marker.title "#{pluralize(event.attendees.size, 'person')} going"
      marker.infowindow render_to_string(partial: '/events/infobox', 
                                         locals: {object: event})
      marker.picture({
        anchor: [10,34],
        url: ActionController::Base.helpers.asset_path('cyan_marker.png'),
        width: 20,
        height: 34 })
      marker.shadow({
        anchor: [2,22],
        url: ActionController::Base.helpers.asset_path('/sprite_shadow.png'),
        width: 29,
        height: 22 })
    end
    respond_with(@events, @hash)
  end

  def show
    @event = Event.find(params[:id])
    @images = @event.images
    respond_with(@event, @images)
  end

  def update
    @event = Event.find(params[:id])
    if @event.update_attributes(event_params)
      flash[:success] = 'Event updated'
      sign_in current_user
    else
      flash[:error] = 'Invalid Event parameters'
    end 
  end

  private
    def admin_user
      redirect_to root_path unless admin?
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to root_path unless current_user?(@user) || admin?
    end

    def event_params
      params[:event].permit!
    end
end
