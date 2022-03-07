class Skill < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :posts
  validates :name, presence: true
  validates :level, presence: true
  scope :most_recent, -> { order(created_at: :desc) }
end
