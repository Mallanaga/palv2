class AttendancesController < ApplicationController
  before_filter :signed_in_user
  respond_to :js

  def create
    @event = Event.find(params[:attendance][:event_id])
    if @event.private?
      current_user.attend!(@event) if current_user.invited?(@event)
    else
      current_user.attend!(@event)
    end
    
    respond_with(@event)
  end

  def destroy
    @event = Attendance.find(params[:id]).event
    current_user.not_attending!(@event)
    respond_with(@event)
  end

end
