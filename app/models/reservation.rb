class Reservation < ApplicationRecord
  before_save :end_date_validation

  belongs_to :user
  belongs_to :provider

  validates :start_date, presence: true, date: { after: proc { Time.now }, before: proc {
                                                                                     Time.now + 6.months
                                                                                   } }
  validates :end_date, presence: true, date: { after: proc { :start_date } }
  validates :total_cost, presence: true, numericality: { greater_than_or_equal_to: 0 }

  private

  def end_date_validation
    throw :abort unless end_date <= start_date + 1.month
  end
end
