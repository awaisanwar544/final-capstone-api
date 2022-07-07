class User < ApplicationRecord
  has_many :reservations
  validates :name, presence: true, length: { maximum: 20 }
  validates :password, presence: true, length: { minimum: 6 }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: true
end
