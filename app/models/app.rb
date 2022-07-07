class App < ApplicationRecord
  before_create :add_token
  validates :name, presence: true

  def add_token
    self.token = JwtHelper::JsonWebToken.encode(name)
  end
end
