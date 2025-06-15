module Mutations
  class CreateTransaction < BaseMutation
    # argument :input, Types::CreateTransactionInput, required: true
    argument :user_id, ID, required: true
    argument :amount, Float, required: true
    argument :transaction_type, String, required: true
    argument :category, String, required: false
    argument :description, String, required: false
    argument :date, GraphQL::Types::ISO8601Date, required: true

    field :transaction, Types::TransactionType, null: true
    field :errors, [ String ], null: false

    def resolve(user_id:, amount:, transaction_type:, category: nil, description: nil, date:)
      user = User.find(user_id)
      transaction = user.transactions.create(
        amount: amount,
        transaction_type: transaction_type,
        category: category,
        description: description,
        date: date
      )

      if transaction.persisted?
        { transaction: transaction, errors: [] }
      else
        { transaction: nil, errors: transaction.errors.full_messages }
      end
    end
  end
end
