class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  acts_as_voter

  extend FriendlyId
  friendly_id :username, use: :slugged

  # ✅ Change jwt_revocation_strategy to JTIMatcher
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable,
         :jwt_authenticatable,
         :omniauthable,
         jwt_revocation_strategy: JwtDenylist

  # Associations
  enum :role, { member: 0, guest: 1, admin: 2 }, default: :member
  
  has_many :identities, dependent: :destroy
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

  # Suggested users based on shared careers
  scope :suggested_for, ->(user) {
    where(id: UserCareer.where(career_id: user.career_ids).select(:user_id))
      .where(role: :member)
      .where.not(id: user.id)
      .where.not(id: user.following_ids)
      .order('RANDOM()')
  }

  # Validations
  validates :username,
            presence: true,
            uniqueness: {
              case_sensitive: false
            },
            length: {
              in: 3..20
            },
            format: {
              with: /\A[a-zA-Z0-9_]+\z/,
              message: "can only contain letters, numbers, and underscores"
            }

  validates :email,
            format: {
              with: URI::MailTo::EMAIL_REGEXP,
              message: "must be a valid email address"
            },
            length: {
              maximum: 255
            }

  validate :password_complexity
  validates :bio, length: { maximum: 500 }, allow_blank: true
  validate :avatar_content_type
  validate :career_limit

  before_create :set_jti

  def confirmation_required?
    false
  end

  def follow(user)
    active_relationships.create(followed_id: user.id)
  end

  def unfollow(user)
    active_relationships.find_by(followed_id: user.id)&.destroy
  end

  def following?(user)
    following.include?(user)
  end

  def relationship_id_for(viewer)
    return nil unless viewer
    viewer.active_relationships.find_by(followed_id: self.id)&.id
  end

  def avatar_url
    return unless avatar.attached?
    Rails.application.routes.url_helpers.url_for(avatar)
  end

  def generate_jwt_token
    token, _ = Devise::JWT.generate_token(self)
    token
  end

  def self.find_or_create_from_oauth(auth, provider)
    transaction do
      # Find existing identity or create new one
      identity = Identity.find_or_initialize_by(provider: provider, uid: auth.uid)

      if identity.persisted?
        # User already exists with this OAuth account
        return identity.user
      end

      # Check if user exists with this email
      user = User.find_by(email: auth.info.email)

      if user
        # Link OAuth to existing user
        identity.user = user
        identity.update_oauth_data(auth)
        return user
      end

      # Create new user
      user = User.new(
        email: auth.info.email,
        password: SecureRandom.hex(20),
        username: generate_username(auth.info),
        first_name: auth.info.first_name,
        last_name: auth.info.last_name
      )

      user.skip_confirmation! if user.respond_to?(:skip_confirmation!)
      user.save!

      identity.user = user
      identity.update_oauth_data(auth)

      user
    end
  end

  private

  def self.generate_username(info)
    base = (info.first_name || info.last_name || 'user').parameterize.underscore
    suffix = SecureRandom.random_number(1000)
    "#{base}_#{suffix}"
  end

  private

  def set_jti
    self.jti ||= SecureRandom.uuid
  end

  def password_complexity
    if password.blank? ||
         password =~
           /\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}\z/
      return
    end

    errors.add :password,
               "must include at least: 1 uppercase, 1 lowercase, 1 digit and 1 special character"
  end

  def avatar_content_type
    return unless avatar.attached?

    unless avatar.content_type.in?(%w[image/jpeg image/jpg image/png image/gif])
      errors.add(:avatar, "must be a JPEG, JPG, PNG, or GIF")
    end

    if avatar.blob.byte_size > 5.megabytes
      errors.add(:avatar, "should be less than 5MB")
    end
  end

  def career_limit
    return if careers.size <= 3
    errors.add(:careers, "can't select more than 3 careers")
  end
end
