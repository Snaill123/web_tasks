require_dependency 'validators/email_validator.rb'
class Feedback < ApplicationRecord
  validates :author, presence: true, length: {minmum: 1, maximum: 20}
  validates :content, length: {minmum: 1, maximum: 500}
  validates :email, presence: true, email: true
end
