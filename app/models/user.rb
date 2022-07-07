class User < ApplicationRecord
  before_create :add_token
  has_many :reservations
  validates :name, presence: true, length: { maximum: 20 }
  validates :password, presence: true, length: { minimum: 6 }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: true

  private

  def add_token
    self.token = JwtHelper::JsonWebToken.encode(id)
  end
end
