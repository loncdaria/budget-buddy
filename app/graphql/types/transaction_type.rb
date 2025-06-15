module Types
  class TransactionType < Types::BaseObject
    field :id, ID, null: false
    field :amount, Float, null: false
    field :transactionType, String, null: false, method: :transaction_type
    field :category, String, null: true
    field :description, String, null: true
    field :date, GraphQL::Types::ISO8601Date, null: false
    field :user, Types::UserType, null: false
  end
end
