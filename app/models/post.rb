class Post < ApplicationRecord
  acts_as_votable
  belongs_to :user
  belongs_to :career
  has_many :skills
  has_many :comments
  validates :title, presence: true, length: { minimum: 5, maximum: 50 }
  validates :content, presence: true, length: { minimum: 10 }
  scope :most_recent, -> { order(created_at: :desc) }
  # validates :content_length { |post| post.errors.add(:content, "is too long (maximum is #{Post::CONTENT_MAX_LENGTH} characters)") if post.content.length > Post::CONTENT_MAX_LENGTH }

  def liked_by?(user)
    likes.where(user_id: user.id).exists?
  end

  def user_career_posts
    self.where(career_id: current_user.career_id).most_recent
  end

  def self.search(search)
    where("title LIKE ? OR content LIKE ?", "%#{search}%", "%#{search}%")
  end

  def self.search(search)
    where("title LIKE ? OR content LIKE ?", "%#{search}%", "%#{search}%")
  end

  def self.search(search)
    where("title LIKE ? OR content LIKE ?", "%#{search}%", "%#{search}%")
  end

  def self.search(search)
    where("title LIKE ? OR content LIKE ?", "%#{search}%", "%#{search}%")
  end

  def self.search(search)
    where("title LIKE ? OR content LIKE ?", "%#{search}%", "%#{search}%")
  end

  def self.search(search)
    where("title LIKE ? OR content LIKE ?", "%#{search}%", "%#{search}%")
  end

  def self.search(search)
    where("title LIKE ? OR content LIKE ?", "%#{search}%", "%#{search}%")
  end

  def self.search(search)
    where("title LIKE ? OR content LIKE ?", "%#{search}%", "%#{search}%")
  end

  def self.search(search)
    where("title LIKE ? OR content LIKE ?", "%#{search}%", "%#{search}%")
  end

  def self.search(search)
    where("title LIKE ? OR content LIKE ?", "%#{search}%", "%#{search}%")
  end

  def self.search(search)
    where("title LIKE ? OR content LIKE ?", "%#{search}%", "%#{search}%")
  end
end
