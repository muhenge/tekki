class Post < ApplicationRecord

  extend FriendlyId
  friendly_id :title, use: :slugged
  
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
  has_one_attached :image

  def self.search(search)
    where("title LIKE ? OR content LIKE ?", "%#{search}%", "%#{search}%")
  end

  def as_json(options = {})
    current_user = options[:current_user]
    super(options.merge(include: { 
      user: { only: [:id, :username, :firstname, :lastname, :slug] },
      careers: { only: [:id, :field] }
    })).merge({
      slug: slug,
      votes_count: get_upvotes.size,
      liked_by_current_user: current_user ? current_user.liked?(self) : false
    })
  end

end
