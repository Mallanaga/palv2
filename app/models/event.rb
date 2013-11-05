class Event < ActiveRecord::Base
  has_many :invites, dependent: :destroy
  has_many :users, through: :invites

  has_many :attendances, dependent: :destroy, 
                         conditions: { cancel: [false, nil] }
  has_many :users, through: :attendances, 
                   conditions: { "attendances.cancel" => [false, nil] }

  validates :name, presence: true, length: { maximum: 120 }
  validates :start, presence: true

  default_scope { order('start') }
end
