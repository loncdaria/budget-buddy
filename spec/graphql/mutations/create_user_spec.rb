require "rails_helper"

RSpec.describe "CreateUser Mutation", type: :request do
  let(:mutation) do
    <<~GQL
      mutation CreateUser($input: CreateUserInput!) {
        createUser(input: $input) {
          user {
            id
            email
          }
          errors
        }
      }
    GQL
  end

  context "with valid input" do
    let(:variables) do
      {
        input: {
          email: "nowy@example.com",
          password: "Haslo123!",
          passwordConfirmation: "Haslo123!"
        }
      }
    end

    it "creates a user and returns no errors" do
      post "/graphql",
     params: { query: mutation, variables: variables }.to_json,
     headers: { "Content-Type" => "application/json" }


      json = JSON.parse(response.body)
      data = json.dig("data", "createUser")

      expect(data["errors"]).to be_empty
      expect(data["user"]["email"]).to eq("nowy@example.com")
    end
  end

  context "with invalid input" do
    let(:variables) do
      {
        input: {
          email: "zlyemail",
          password: "123",
          passwordConfirmation: "456"
        }
      }
    end

    it "returns validation errors" do
      post "/graphql",
     params: { query: mutation, variables: variables }.to_json,
     headers: { "Content-Type" => "application/json" }


      json = JSON.parse(response.body)
      data = json.dig("data", "createUser")

      expect(data["errors"]).not_to be_empty
      expect(data["user"]).to be_nil
    end
  end
end
