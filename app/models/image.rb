class Image < ActiveRecord::Base
  belongs_to :user
  belongs_to :event

  def self.by_votes
    select('images.*, coalesce(value, 0) as votes').
    joins('left join image_votes on image_id=images.id').
    order('votes desc')
  end

  def votes
    read_attribute(:votes) || image_votes.sum(:value)
  end
end
