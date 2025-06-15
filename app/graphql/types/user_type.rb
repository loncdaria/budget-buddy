module Types
  class UserType < Types::BaseObject
    field :id, ID, null: false
    field :email, String, null: false
    field :transactions, [Types::TransactionType], null: true
  end
end
