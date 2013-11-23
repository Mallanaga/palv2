class ActivitiesController < ApplicationController
  respond_to :js
  
  def index
    @activities = PublicActivity::Activity.order('created_at DESC').where(recipient_id: current_user.id, recipient_type: 'User')
    respond_with(@activities)
    @activities = @activities.where(viewed: false).each do |a|
      a.update_attributes(viewed: true)
    end
  end
end
