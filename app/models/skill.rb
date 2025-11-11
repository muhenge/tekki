class Skill < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :posts, dependent: :destroy

  validates :name, presence: true, uniqueness: { scope: :user_id }

  scope :most_recent, -> { order(created_at: :desc) }
end
