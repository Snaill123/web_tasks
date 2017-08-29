require_dependency 'validators/email_validator.rb'
class Admin < ApplicationRecord
	validates :name, presence: true, length: {minimum: 2,maximum: 20},uniqueness: true
	validates :email,presence: true, email: true, uniqueness: true
	validates :password, presence: true, length: {minimum: 6}
	has_many :posts

	has_secure_password
end
