class Attendance < ActiveRecord::Base

  belongs_to :event, dependent: :destroy
  belongs_to :user

  validates :event_id, presence: true
  validates :user_id, presence: true
  
end
