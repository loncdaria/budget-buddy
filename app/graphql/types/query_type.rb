# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :node, Types::NodeType, null: true, description: "Fetches an object given its ID." do
      argument :id, ID, required: true, description: "ID of the object."
    end

    def node(id:)
      context.schema.object_from_id(id, context)
    end

    field :nodes, [ Types::NodeType, null: true ], null: true, description: "Fetches a list of objects given a list of IDs." do
      argument :ids, [ ID ], required: true, description: "IDs of the objects."
    end

    def nodes(ids:)
      ids.map { |id| context.schema.object_from_id(id, context) }
    end

    # Example field - zostawiam dla testów
    field :test_field, String, null: false, description: "An example field added by the generator"
    def test_field
      "Hello World!"
    end

    field :transactions, resolver: Resolvers::TransactionsResolver

    def transactions
      user = context[:current_user]
      raise GraphQL::ExecutionError, "Unauthorized" if user.nil?

      user.transactions
    end


    field :total_transactions_by_type, Float, null: false do
      argument :user_id, ID, required: true
      argument :transactionType, String, required: true
      argument :start_date, GraphQL::Types::ISO8601Date, required: true
      argument :end_date, GraphQL::Types::ISO8601Date, required: true
    end

    def total_transactions_by_type(user_id:, transactionType:, start_date:, end_date:)
      User.find(user_id)
          .transactions
          .where(transaction_type: transactionType, date: start_date..end_date)
          .sum(:amount)
    end

    field :total_transactions, Float, null: false do
      argument :user_id, ID, required: true
      argument :start_date, GraphQL::Types::ISO8601Date, required: true
      argument :end_date, GraphQL::Types::ISO8601Date, required: true
    end

    def total_transactions(user_id:, start_date:, end_date:)
      User.find(user_id)
          .transactions
          .where(date: start_date..end_date)
          .sum(:amount)
    end

    field :average_transaction_amount, Float, null: false do
      argument :user_id, ID, required: true
      argument :transactionType, String, required: true
      argument :start_date, GraphQL::Types::ISO8601Date, required: true
      argument :end_date, GraphQL::Types::ISO8601Date, required: true
    end

    def average_transaction_amount(user_id:, transactionType:, start_date:, end_date:)
      User.find(user_id)
          .transactions
          .where(transaction_type: transactionType, date: start_date..end_date)
          .average(:amount)
    end

    field :transaction_count, Integer, null: false do
      argument :user_id, ID, required: true
      argument :start_date, GraphQL::Types::ISO8601Date, required: true
      argument :end_date, GraphQL::Types::ISO8601Date, required: true
    end

    def transaction_count(user_id:, start_date:, end_date:)
      User.find(user_id)
          .transactions
          .where(date: start_date..end_date)
          .count
    end

      field :total_expenses_by_category, Float, null: false do
      argument :user_id, ID, required: true
      argument :category, String, required: true
      argument :start_date, GraphQL::Types::ISO8601Date, required: false
      argument :end_date, GraphQL::Types::ISO8601Date, required: false
    end

    def total_expenses_by_category(user_id:, category:, start_date: nil, end_date: nil)
      # Jeśli nie podano dat, ustalamy domyślnie ostatni miesiąc
      if start_date.nil? || end_date.nil?
        end_date = Date.today.end_of_month
        start_date = end_date.beginning_of_month
      end

      # Pobieramy transakcje użytkownika, filtrowane po kategorii i dacie
      User.find(user_id)
          .transactions
          .where(transaction_type: "expense", category: category, date: start_date..end_date)
          .sum(:amount)
    end
  end
end
