require_dependency 'validators/email_validator.rb'
class User < ApplicationRecord
  validates :name, presence: true, length: {minimum: 1, maximum: 20}, uniqueness: true
  validates :email, presence: true, email: true, uniqueness: true
  validates :password, presence: true, length: {minimum: 6, maximum: 16}
  has_many :posts
  has_secure_password
end
