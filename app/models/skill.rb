class Skill < ApplicationRecord
  has_and_belongs_to_many :providers, dependent: :destroy

  validates :name, presence: true
  validates :name, uniqueness: true
end
