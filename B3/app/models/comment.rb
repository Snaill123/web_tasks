class Comment < ApplicationRecord
  belongs_to :post
  validates :author,presence: true,uniqueness: true
  validates :content,length: {minimum: 5,maximum: 500}
end
