class User < ActiveRecord::Base
  has_secure_password validations: false

  has_many :invites, dependent: :destroy
  has_many :events, through: :invites

  has_many :attendances, dependent: :destroy, 
                         conditions: { cancel: [false, nil] }
  has_many :events, through: :attendances,
                    conditions: { "attendances.cancel" => [false, nil] }

  before_save { self.email = email.downcase.strip }
  before_save :create_remember_token

  validates :name, presence: true, length: { maximum: 50 }
  validates :password, length: { minimum: 6 }, on: :create
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, 
                    format: { with: VALID_EMAIL_REGEX }, 
                    uniqueness: { case_sensitive: false }

  # name formatting
  def first_name
    self.name.split(' ').first
  end
  def last_name
    self.name.split(' ').last
  end  
      
  # invites
  def invited? (event)
    self.invites.find_by_event_id(event.id)
  end
  def invite! (event)
    self.invites.create!(event_id: event.id)
  end
  def uninvite! (event)
    self.invites.find_by_event_id(event.id).destroy
  end

  # attendances
  def attending? (event)
    self.attendances.find_by_event_id(event.id)
  end
  def attend! (event)
    if attd = Attendance.find_by_event_id_and_user_id(event.id, self.id)
      attd.update_attribute(:cancel, false)
    else
      self.attendances.create!(event_id: event.id, iCalUID: "#{SecureRandom.uuid.split('-')[4]}@palendar")
    end
  end
  def not_attending! (event)
    self.attendances.find_by_event_id(event.id).update_attribute(:cancel, true)
  end

  # password reset
  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver
  end
  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end

  private
    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end


