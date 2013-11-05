class EventsController < ApplicationController
  include ActionView::Helpers::TextHelper

  before_filter :admin_user,     only: [:destroy]
  before_filter :correct_user,   only: [:edit, :update]
  before_filter :signed_in_user, only: [:create, :destroy, :edit, :new, :update]

  respond_to :html, :js

  def create
    @event = current_user.events.build(event_params)
    if @event.save
      current_user.invite!(@event)
      flash[:success] = "'#{@event.name}' created"
      redirect_back_or root_url
    else
      @events = []
      flash[:error] = 'Invalid Event parameters'
      render 'events/new'
    end
  end

  def destroy
    Event.find(params[:id]).destroy
    flash[:success] = 'Event destroyed'
  end

  def edit
    @event = Event.find(params[:id])
  end

  def find
    # geocode params[:location]
    date = params[:date].to_date
    @events = Event.where(start: date.beginning_of_day.. date.end_of_day,
                          finish: date.beginning_of_day.. date.end_of_day)
    @hash = Gmaps4rails.build_markers(@events) do |event, marker|
      marker.lat event.lat
      marker.lng event.lng
      # marker.title "#{pluralize(event.users.size, 'person')} going"
      marker.infowindow render_to_string(partial: '/events/infobox', 
                                         locals: {object: event})
    end

    respond_with(@events, @hash)
  end

  def index
    date = Date.current
    @events = Event.where(start: date.beginning_of_day.. date.end_of_day,
                          finish: date.beginning_of_day.. date.end_of_day)
    @hash = Gmaps4rails.build_markers(@events) do |event, marker|
      marker.lat event.lat
      marker.lng event.lng
      # marker.title "#{pluralize(event.users.size, 'person')} going"
      marker.infowindow render_to_string(partial: '/events/infobox', 
                                         locals: {object: event}) 
    end
  end

  def new
    @event = Event.new

    respond_with(@event)
  end

  def show
    @event = Event.find(params[:id])

    respond_with(@event)
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
