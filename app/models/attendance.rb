# == Schema Information
#
# Table name: attendances
#
#  id         :integer          not null, primary key
#  event_id   :integer
#  user_id    :integer
#  iCalUID    :string(255)
#  cancel     :boolean          default(FALSE)
#  created_at :datetime
#  updated_at :datetime
#

class Attendance < ActiveRecord::Base
  include PublicActivity::Common
  
  belongs_to :event, dependent: :destroy
  belongs_to :user

  validates :event_id, presence: true
  validates :user_id, presence: true
  
end
