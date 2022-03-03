class Post < ApplicationRecord
  belongs_to :user
  # has_many :comments
  # has_many :likes
  # has_many :liked_users, through: :likes, source: :user

  validates :title, presence: true, length: { minimum: 5, maximum: 50 }
  validates :content, presence: true, length: { minimum: 10 }
  scope :most_recent, -> { order(created_at: :desc) }
  # validates :content_length { |post| post.errors.add(:content, "is too long (maximum is #{Post::CONTENT_MAX_LENGTH} characters)") if post.content.length > Post::CONTENT_MAX_LENGTH }

end
