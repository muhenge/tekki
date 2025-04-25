class Career < ApplicationRecord
  has_many :post_careers
  has_many :posts, through: :post_careers
  has_many :user_careers
  has_many :users, through: :user_careers
end
