# app/models/payment.rb
class Payment < ApplicationRecord
  belongs_to :student
  has_one_attached :receipt

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :payment_id, presence: true, uniqueness: true
end
