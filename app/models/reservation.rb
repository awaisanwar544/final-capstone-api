class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :provider

  validates :start_date, presence: true, date: { after: Proc.new { Time.now }, before: Proc.new { Time.now + 6.months } }
  validates :end_date, presence: true, date: { after: Proc.new { :start_date } }
  validates :total_cost, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
