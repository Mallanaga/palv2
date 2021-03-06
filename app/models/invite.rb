# == Schema Information
#
# Table name: invites
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  event_id   :integer
#  created_at :datetime
#  updated_at :datetime
#

class Invite < ActiveRecord::Base
  include PublicActivity::Common
  
  belongs_to :event
  belongs_to :user
  
  validates :event_id, presence: true
  validates :user_id, presence: true
end
