class Category < ActiveRecord::Base
  has_many :tags, dependent: :destroy
  has_many :events, through: :tags

  validates :name, presence: true,
                   uniqueness: {case_sensitive: false}

  def self.tokens(query)
    filter_query = query.gsub(/[^a-zA-Z0-9&\s]/, '')
    filter_query = filter_query.strip.downcase
    categories = Rails.env.development? ? Category.where("LOWER(name) LIKE ?", "%#{filter_query}%") : Category.where("LOWER(name) ILIKE ?", "%#{filter_query}%")
    categories << {id: "<<<#{query}>>>", name: "New: \"#{filter_query}\""}
  end

  def self.ids_from_tokens(tokens)
    tokens.gsub!(/<<<(.+?)>>>/) { create!(name: $1).id }
    tokens.split(',')
  end
end
