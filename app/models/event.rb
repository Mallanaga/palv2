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
  has_many :images

  has_many :comments
  
  has_many :invites, dependent: :destroy
  has_many :invitees, through: :invites, source: :user

  belongs_to :user

  has_many :attendances, dependent: :destroy              
  has_many :attendees, -> { where "attendances.cancel" => false },
                       through: :attendances, source: :user

  has_many :tags, dependent: :destroy
  has_many :categories, through: :tags
                   
  validates :name, presence: true, length: { maximum: 120 }
  # validates :startDate, presence: true
  validates_presence_of :lat, message: "couldn't be found"

  default_scope { order('start') }

  before_save :convert_to_start, :convert_to_finish

  def self.locals(lat, lng, range)
    # cos function is good up to 60 people.
    self.select do |e| 
      people = e.attendees.size > e.est_att.to_i ? e.attendees.size : e.est_att.to_i
      aoi = people < 61 ? (people**2)/120 : 30
      coorDist(e.lat, e.lng, lat.to_f, lng.to_f) - aoi < range
    end
  end
  
  attr_reader :category_tokens
  def category_tokens=(tokens)
    self.category_ids = Category.ids_from_tokens(tokens)
  end

  # Start
  def startDate
    start.strftime("%Y-%m-%d") if start.present?
  end 
  def startDate=(date)
    # Change back to datetime friendly format
    @startDate = Date.parse(date).strftime("%Y-%m-%d")
  end

  def startTime
    start.strftime("%I:%M%P") if start.present?
  end
  def startTime=(time)
    # Change back to datetime friendly format
    @startTime = Time.parse(time).strftime("%H:%M:%S")
  end
  
  def convert_to_start
    self.start = DateTime.parse("#{@startDate} #{@startTime}")
  end

  # Finish
  def finishDate
    finish.strftime("%Y-%m-%d") if finish.present?
  end
  def finishDate=(date)
    # Change back to datetime friendly format
    @finishDate = Date.parse(date).strftime("%Y-%m-%d")
  end

  def finishTime
    finish.strftime("%I:%M%P") if finish.present?
  end
  def finishTime=(time)
    # Change back to datetime friendly format
    @finishTime = Time.parse(time).strftime("%H:%M:%S")
  end

  def convert_to_finish
    self.finish = DateTime.parse("#{@finishDate} #{@finishTime}")
  end

end

private
  def coorDist(lat1, lon1, lat2, lon2)
    # Earth's radius in KM
    earthRadius = 6371
      # convert degrees to radians
      def convDegRad(value)
        unless value.nil? or value == 0
              value = (value/180) * Math::PI
        end
        return value
      end
    deltaLat = (lat2-lat1)
    deltaLon = (lon2-lon1)
    deltaLat = convDegRad(deltaLat)
    deltaLon = convDegRad(deltaLon)
    # Calculate square of half the chord length between latitude and longitude
    a = Math.sin(deltaLat/2) * Math.sin(deltaLat/2) +
        Math.cos((lat1/180 * Math::PI)) * Math.cos((lat2/180 * Math::PI)) *
        Math.sin(deltaLon/2) * Math.sin(deltaLon/2); 
    # Calculate the angular distance in radians
    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
    distance = earthRadius * c
  end
