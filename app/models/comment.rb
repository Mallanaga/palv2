class Comment < ActiveRecord::Base
  belongs_to :event
  belongs_to :user

  default_scope { order('created_at DESC') }

  validates :event_id, presence: true
  validates :user_id, presence: true
end
