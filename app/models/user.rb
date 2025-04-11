class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  acts_as_voter

  extend FriendlyId
  friendly_id :username, use: :slugged

  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable,
         :jwt_authenticatable,
         :confirmable,
         jwt_revocation_strategy: JwtDenylist

  # Associations
  has_many :user_careers, dependent: :destroy
  has_many :careers, through: :user_careers
  has_many :posts, dependent: :destroy
  has_one_attached :avatar
  has_many :active_relationships,
           class_name: "Relationship",
           foreign_key: "follower_id",
           dependent: :destroy
  has_many :passive_relationships,
           class_name: "Relationship",
           foreign_key: "followed_id",
           dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships
  has_many :comments, dependent: :destroy
  has_many :skills, dependent: :destroy
  accepts_nested_attributes_for :skills, allow_destroy: true

  # Username validations
  validates :username,
            presence: true,
            uniqueness: { case_sensitive: false },
            length: { in: 3..20 },
            format: {
              with: /\A[a-zA-Z0-9_]+\z/,
              message: "can only contain letters, numbers, and underscores"
            }

  validates :email,
            format: {
              with: URI::MailTo::EMAIL_REGEXP,
              message: "must be a valid email address"
            },
            length: { maximum: 255 }

  validate :password_complexity

  validates :bio, length: { maximum: 500 }, allow_blank: true
  validate :avatar_content_type
  validate :career_limit

  # Instance methods
  def follow(user)
    active_relationships.create(followed_id: user.id)
  end

  def unfollow(user)
    active_relationships.find_by(followed_id: user.id)&.destroy
  end

  def following?(user)
    following.include?(user)
  end

  def avatar_url
    return unless avatar.attached?
    Rails.application.routes.url_helpers.url_for(avatar)
  end

  # JWT methods
  before_create :set_jti

  private

  def set_jti
    self.jti ||= SecureRandom.uuid
  end

  def password_complexity
    return if password.blank? || password =~ /\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}\z/

    errors.add :password, 'must include at least: 1 uppercase, 1 lowercase, 1 digit and 1 special character'
  end

  def avatar_content_type
    return unless avatar.attached?

    unless avatar.content_type.in?(%w[image/jpeg image/jpg image/png image/gif])
      errors.add(:avatar, 'must be a JPEG, JPG, PNG, or GIF')
    end

    if avatar.blob.byte_size > 5.megabytes
      errors.add(:avatar, 'should be less than 5MB')
    end
  end

  def career_limit
    return if careers.size <= 3
    errors.add(:careers, "can't select more than 3 careers")
  end
  def generate_login_token!
    self.login_token = SecureRandom.hex(10)
    self.login_token_sent_at = Time.current
    save!
  end
end
