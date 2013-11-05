class Invite < ActiveRecord::Base

  belongs_to :event, dependent: :destroy
  belongs_to :user
  
end
