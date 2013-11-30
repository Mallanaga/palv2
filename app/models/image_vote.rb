class ImageVote < ActiveRecord::Base
  belongs_to :user
  belongs_to :image
  
  validates_uniqueness_of :image_id, scope: :user_id
  validates_inclusion_of :value, in: [1, -1]
  validate :ensure_not_author

  def ensure_not_author
    errors.add :user_id, "is the author of the image" if image.user_id == user_id
  end

  after_save :ci_lower_bound

private

  def ci_lower_bound
    pos = ImageVote.where(value: 1, image_id: self.image_id).size
    n = ImageVote.where(image_id: self.image_id).size
    if n == 0
      return 0
    end
    z = 1.96
    phat = 1.0*pos/n
    self.image.update_attributes(rank: (phat + z*z/(2*n) - z * Math.sqrt((phat*(1-phat)+z*z/(4*n))/n))/(1+z*z/n))
  end

end
