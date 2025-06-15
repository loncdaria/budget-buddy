class Transaction < ApplicationRecord
  belongs_to :user

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :transaction_type, presence: true, inclusion: { in: %w[income expense] }
  validates :category, presence: true, unless: -> { transaction_type == "income" }
  validates :date, presence: true
end
