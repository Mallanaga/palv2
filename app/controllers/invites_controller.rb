class InvitesController < ApplicationController
  before_filter :signed_in_user
  respond_to :js
end
