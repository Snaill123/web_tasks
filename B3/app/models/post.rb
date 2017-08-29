class Post < ApplicationRecord
  validates :title,presence: true, uniqueness: true
  validates :content, presence: true, length: {minimum: 50, maximum: 3000}
  belongs_to :admin
  has_many :comments
end
