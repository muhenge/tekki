class Post < ApplicationRecord
  acts_as_votable
  belongs_to :user
  has_many :post_careers
  has_many :careers, through: :post_careers
  has_many :skills
  has_many :comments
  validates :title, presence: true, length: { minimum: 5, maximum: 50 }
  validates :content, presence: true, length: { minimum: 10 }
  scope :most_recent, -> { order(created_at: :desc) }
  scope :for_career_ids, ->(career_ids) { joins(:careers).where(careers: { id: career_ids }).distinct if career_ids.present? }
  # validates :content_length { |post| post.errors.add(:content, "is too long (maximum is #{Post::CONTENT_MAX_LENGTH} characters)") if post.content.length > Post::CONTENT_MAX_LENGTH }

  def self.search(search)
    where("title LIKE ? OR content LIKE ?", "%#{search}%", "%#{search}%")
  end

end
