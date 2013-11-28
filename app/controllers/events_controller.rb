class EventsController < ApplicationController
  include ActionView::Helpers::TextHelper

  before_filter :correct_user,   only: [:update, :destroy]
  before_filter :signed_in_user, only: [:create, :destroy, :edit, :new, :update]
  respond_to :html, :js, :json

  def create
    tz = JSON.load(open("https://maps.googleapis.com/maps/api/timezone/json?location=#{params[:event][:lat]},#{params[:event][:lng]}&timestamp=1331161200&sensor=false"))["timeZoneId"]
    Chronic.time_class = ActiveSupport::TimeZone.create(tz)
    params[:event][:user_id] = current_user.id
    params[:event][:finishDate] = params[:event][:startDate].to_date if params[:event][:finishDate].blank?
    @event = current_user.events.build(event_params)
    if @event.save
      if @event.private?
        current_user.invite!(@event)
        current_user.attend!(@event)
        params[:invited].split(',').each do |u|
          u = User.find(u)
          u.invite!(@event)
          Invite.find_by_user_id_and_event_id(u.id, @event.id).create_activity :create, owner: current_user, recipient: u
        end
      else
        current_user.attend!(@event)
        current_user.sharees.each do |s|
          if !s.attending?(@event)
            Attendance.find_by_event_id_and_user_id(@event.id, current_user.id).create_activity :create, owner: current_user, recipient: s
          end
        end
      end
      flash.now[:success] = "'#{@event.name}' created"
      respond_with(@event)
    else
      render 'events/new'
    end
    
  end

  def destroy
    @event = Event.find(params[:id]).destroy
    respond_with()
  end

  def edit
    @event = Event.find(params[:id])
    respond_with(@event)
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

  def import
    count = Event.import(params[:file])
    if count > 0
      flash[:success] = "Events updated with #{count} new things!"
    else
      flash[:error] = "No events updated..."
    end
    redirect_to root_url
  end

  def index

  end

  def new
    @event = Event.new
    respond_with(@event)
  end

  def pals
    @events = []
    current_user.sharers.each do |u|
      # public events of your pals
      @events += u.attended_events.where('finish >= ?', Date.current.beginning_of_day)
                                  .where(:private => false)
      # private events of your pals where you were also invited
      @events += (u.attended_events.where('finish >= ?', Date.current.beginning_of_day)
                  .where(:private => true) & 
                  current_user.invited_events.where('finish >= ?', Date.current.beginning_of_day)
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
        url: ActionController::Base.helpers.asset_path('sprite_shadow.png'),
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
    tz = JSON.load(open("https://maps.googleapis.com/maps/api/timezone/json?location=#{@event.lat},#{@event.lng}&timestamp=1331161200&sensor=false"))["timeZoneId"]
    Chronic.time_class = ActiveSupport::TimeZone.create(tz)
    @event.update_attributes(event_params)
    respond_with(@event)
  end

  private

    def correct_user
      @user = Event.find(params[:id]).user
      redirect_to(root_path) unless current_user?(@user)
    end

    def event_params
      params[:event].permit!
    end
end
