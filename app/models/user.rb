class User < ActiveRecord::Base
  has_many :posts
  has_many :paragraphs, through: :posts
  has_secure_password

  validates :email, :password, presence: true
end
