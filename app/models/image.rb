class Image < ActiveRecord::Base
  belongs_to :user
  belongs_to :event

  has_many :image_votes, dependent: :destroy

  default_scope { order('rank desc') }

  def taken_by? (photographer)
    self.user == photographer
  end

  def total_votes
    ImageVote.joins(:image).where(images: {image_id: self.id}).sum('value')
  end

  def votes
    read_attribute(:votes) || image_votes.sum(:value)
  end

end
