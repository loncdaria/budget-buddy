module Types
  class CreateTransactionInput < Types::BaseInputObject
    argument :user_id, ID, required: true
    argument :amount, Float, required: true
    argument :transaction_type, String, required: true
    argument :category, String, required: false
    argument :description, String, required: false
    argument :date, GraphQL::Types::ISO8601Date, required: true
  end
end
