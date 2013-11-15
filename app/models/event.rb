# == Schema Information
#
# Table name: events
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  start      :datetime
#  why        :text
#  location   :string(255)
#  lat        :float
#  lng        :float
#  private    :boolean          default(FALSE)
#  created_at :datetime
#  updated_at :datetime
#  finish     :datetime
#  user_id    :integer
#

class Event < ActiveRecord::Base
  has_many :invites, dependent: :destroy
  has_many :invitees, through: :invites, source: :user

  belongs_to :user

  has_many :attendances, -> { where cancel: false }, dependent: :destroy              
  has_many :attendees, -> { where "attendances.cancel" => false },
                       through: :attendances, source: :user
                   
  validates :name, presence: true, length: { maximum: 120 }
  validates :start, presence: true
  validates_presence_of :lat, message: "couldn't be found"

  default_scope { order('start') }
end
