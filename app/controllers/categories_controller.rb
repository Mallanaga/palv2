class CategoriesController < ApplicationController
  respond_to :js, :json

  def create
    @categories = Category.order(:name)
    render json: @categories.tokens(params[:q].gsub(/^[#]/, ''))
  end

  def find
    date = params[:date].to_date
    range = signed_in? ? current_user.range : 10
    days_events = Event.where("start <= ? AND finish >= ?", date.end_of_day,
                              date.beginning_of_day)
                       .where(:private => false)
                       .where(categories: params[:tags])
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
    @categories = Rails.env.development? ? Category.where("LOWER(name) like ?", "%#{params[:q].gsub(/^[#]/, '')}%") : Category.where("LOWER(name) ilike ?", "%#{params[:q].gsub(/^[#]/, '')}%")
    render json: @categories
  end
  
end
