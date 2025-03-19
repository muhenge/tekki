class Skill < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :posts, dependent: :destroy

  VALID_LEVELS = ["Beginner", "Intermediate", "Advanced"].freeze

  validates :name, presence: true, uniqueness: { scope: :user_id }
  validates :level, presence: true, inclusion: { in: VALID_LEVELS }

  scope :most_recent, -> { order(created_at: :desc) }
end
