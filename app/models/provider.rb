class Provider < ApplicationRecord
  has_many :reservations
  has_many :skills
  has_one_attached :avatar

  validates :name, presence: true, length: { maximum: 50 }
  validates :bio, presence: true
  validates :cost, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :image, presence: true
end
