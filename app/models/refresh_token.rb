class RefreshToken < ApplicationRecord
  belongs_to :user

  validates :token, presence: true, uniqueness: true
  validates :expires_at, presence: true

  scope :active,
        -> { where(revoked: false).where("expires_at > ?", Time.current) }

  def self.generate_token
    SecureRandom.urlsafe_base64(32)
  end

  def self.create_for_user(user, ttl: 30.days)
    create!(
      user: user,
      token: generate_token,
      expires_at: ttl.from_now,
      revoked: false
    )
  end

  def valid_token?
    !revoked && expires_at > Time.current
  end

  def revoke!
    update!(revoked: true, revoked_at: Time.current)
  end
end
