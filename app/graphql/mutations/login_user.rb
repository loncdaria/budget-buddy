module Mutations
  class LoginUser < BaseMutation
    argument :email, String, required: true
    argument :password, String, required: true

    field :token, String, null: false
    field :user, Types::UserType, null: false

    def resolve(email:, password:)
      user = User.find_by(email: email)
      if user&& user.authenticate(password)
        token = JsonWebToken.encode(user_id: user.id)
        { user: user, token: token }
      else
        raise GraphQL::ExecutionError, "Invalid credentials"
      end
    end
  end
end
