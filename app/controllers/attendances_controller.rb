class AttendancesController < ApplicationController
  before_filter :signed_in_user
  respond_to :js

  def create
    @event = Event.find(params[:attendance][:event_id])
    if @event.private?
      current_user.attend!(@event) if current_user.invited?(@event)
    else
      current_user.attend!(@event)
      current_user.sharees.each do |s|
        if !s.attending?(@event)
          Attendance.find_by_event_id_and_user_id(@event.id, current_user.id).create_activity :create, owner: current_user, recipient: s
        end
      end
    end
    
    respond_with(@event)
  end

  def destroy
    @event = Attendance.find(params[:id]).event
    current_user.not_attending!(@event)
    respond_with(@event)
  end

end
