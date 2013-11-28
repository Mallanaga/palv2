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
  reverse_geocoded_by :lat, :lng, address: :location
  geocoded_by :location, latitude: :lat, longitude: :lng

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
      Geocoder::Calculations.distance_between([e.lat,e.lng], [lat.to_f,lng.to_f])- aoi < range 
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
    @startDate = Chronic.parse(date).strftime("%Y-%m-%d")
  end

  def startTime
    start.strftime("%I:%M%P") if start.present?
  end
  def startTime=(time)
    # Change back to datetime friendly format
    @startTime = Chronic.parse(time).strftime("%H:%M:%S")
  end
  
  def convert_to_start
    self.start = Chronic.parse("#{@startDate} #{@startTime}")
  end

  # Finish
  def finishDate
    finish.strftime("%Y-%m-%d") if finish.present?
  end
  def finishDate=(date)
    # Change back to datetime friendly format
    @finishDate = Chronic.parse(date).strftime("%Y-%m-%d")
  end

  def finishTime
    finish.strftime("%I:%M%P") if finish.present?
  end
  def finishTime=(time)
    # Change back to datetime friendly format
    @finishTime = Chronic.parse(time).strftime("%H:%M:%S")
  end

  def convert_to_finish
    self.finish = Chronic.parse("#{@finishDate} #{@finishTime}")
  end

  def self.import(file)
    #number of Events updated
    ct = 0

    CSV.foreach(file.path, headers: true) do |row|
      # name
      name = row['what'] || 
             row['name']

      # location
      location = row['where'] || 
                 row['location']
      if location
        latLng = Geocoder.coordinates(location)
        tz = JSON.load(open("https://maps.googleapis.com/maps/api/timezone/json?location=#{latLng[0]},#{latLng[1]}&timestamp=1331161200&sensor=false"))["timeZoneId"]
        Chronic.time_class = ActiveSupport::TimeZone.create(tz)
        # when 
        start = Chronic.parse(row['when'].to_s) || 
                Chronic.parse(row['date'].to_s + ' ' + row['time'].to_s)
      end
      
      # description
      description = row['why'] || 
                    row['about']

      if name && location && start
        self.create! name: name, 
                     location: location,
                     start: start,
                     finish: start + 2.hours,
                     description: description
        ct += 1
        puts "Event for #{name} in #{tz} timezone added to palendar!"
      else
        puts "Not enough info, skipping..."
      end
    end
    ct
  end

end