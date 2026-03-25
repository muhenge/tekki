class Identity < ApplicationRecord
  belongs_to :user

  validates :provider, :uid, presence: true
  validates :uid, uniqueness: { scope: :provider }

  scope :google, -> { where(provider: 'google_oauth2') }
  scope :microsoft, -> { where(provider: 'microsoft_office365') }
  scope :apple, -> { where(provider: 'apple') }

  def update_oauth_data(auth)
    update(
      name: auth.info.name,
      email: auth.info.email,
      avatar: auth.info.image,
      tokens: auth.credentials.to_json
    )
  end
end
