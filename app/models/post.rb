class Post < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged

  acts_as_votable
  belongs_to :user
  has_many :post_careers
  has_many :careers, through: :post_careers
  has_many :skills
  has_many :comments
  before_validation :set_author_from_user, on: :create
  validates :title, presence: true, length: { minimum: 5, maximum: 50 }
  validates :content, presence: true, length: { minimum: 10 }
  validates :author, presence: true




  scope :most_recent, -> { order(created_at: :desc) }
  scope :for_career_ids, ->(career_ids) {
    if career_ids.present?
      left_outer_joins(:post_careers)
        .where("posts.career_id IN (?) OR post_careers.career_id IN (?)", career_ids, career_ids)
        .distinct
    end
  }
  scope :search_by_title, ->(query) { where("title ILIKE ?", "%#{query}%") if query.present? }

  # validates :content_length { |post| post.errors.add(:content, "is too long (maximum is #{Post::CONTENT_MAX_LENGTH} characters)") if post.content.length > Post::CONTENT_MAX_LENGTH }
  has_many_attached :images

  def self.search(query)
    if query.present?
      where("title ILIKE ? OR content ILIKE ?", "%#{query}%", "%#{query}%")
    else
      all
    end
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

  private

  def set_author_from_user
    return if author.present? || user.blank?

    self.author =
      user.username.presence ||
      [user.firstname, user.lastname].compact.join(" ").presence ||
      user.email
  end

end
