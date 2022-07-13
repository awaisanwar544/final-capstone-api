class Provider < ApplicationRecord
  include Rails.application.routes.url_helpers

  has_many :reservations, dependent: :destroy
  has_and_belongs_to_many :skills, dependent: :destroy
  has_one_attached :image

  validates :name, presence: true, length: { maximum: 50 }
  validates :bio, presence: true
  validates :cost, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :image, presence: true

  def image_url
    url_for(image)
  end
end
