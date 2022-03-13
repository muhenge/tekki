class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user
  scope :most_recent, -> { order(created_at: :desc) }
  validates :text, presence: :true
  
  
end
