class User < ActiveRecord::Base
  has_many :posts
  has_many :paragraphs, through: :posts
  has_secure_password
end
