class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  acts_as_voter

  extend FriendlyId
  friendly_id :username, use: :slugged

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist
  has_many :user_careers
  has_many :careers, through: :user_careers
  has_many :posts
  has_one_attached :avatar
  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships
  has_many :comments, dependent: :destroy
  has_many :skills, dependent: :destroy
  accepts_nested_attributes_for :skills
  validates :email, format: URI::MailTo::EMAIL_REGEXP



  # def jwt_payload
  #   super
  # end
  def follow(user)
    active_relationships.create(followed_id: user.id)
  end

  def unfollow(user)
    active_relationships.find_by(followed_id: user.id).destroy
  end

  def following?(user)
    following.include?(user)
  end

  def get_image_url
    url_for(self.avatar)
  end

  def get_image_url
    url_for(self.avatar)
  end

  before_create :set_jti

  private

  def set_jti
    self.jti ||= SecureRandom.uuid
  end

  private

  def career_limit
    if careers.size > 3
      errors.add(:careers, "can't select more than 3 careers")
    end
  end
end
