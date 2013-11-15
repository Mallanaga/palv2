# == Schema Information
#
# Table name: relationships
#
#  id         :integer          not null, primary key
#  sharee_id  :integer
#  sharer_id  :integer
#  created_at :datetime
#  updated_at :datetime
#

class Relationship < ActiveRecord::Base
  include PublicActivity::Common
  # tracked owner: ->(controller, model) { controller && controller.current_user }
  
  belongs_to :sharee, class_name: "User"
  belongs_to :sharer, class_name: "User"

  validates :sharee_id, presence: true
  validates :sharer_id, presence: true
end
