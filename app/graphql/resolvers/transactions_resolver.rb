# frozen_string_literal: true

module Resolvers
  class TransactionsResolver < GraphQL::Schema::Resolver
    type [ Types::TransactionType ], null: false

    def resolve
      user = context[:current_user]
      raise GraphQL::ExecutionError, "Unauthorized" unless user

      user.transactions
    end
  end
end
