require "rails_helper"

RSpec.describe "CreateTransaction Mutation", type: :request do
  let!(:user) { create(:user) }

  let(:mutation) do
    <<~GQL
      mutation CreateTransaction($input: CreateTransactionInput!) {
        createTransaction(input: $input) {
          transaction {
            id
            amount
            transactionType
            category
            description
            date
          }
          errors
        }
      }
    GQL
  end

  context "when valid input is provided" do
    let(:variables) do
      {
        input: {
          userId: user.id,
          amount: 120.5,
          transactionType: "expense",
          category: "groceries",
          description: "Zakupy w Lidlu",
          date: "2025-06-01"
        }
      }
    end

    it "creates a transaction and returns no errors" do
      post "/graphql",
     params: { query: mutation, variables: variables }.to_json,
     headers: { "Content-Type" => "application/json" }



      json = JSON.parse(response.body)
      data = json.dig("data", "createTransaction")

      expect(data["errors"]).to be_empty
      expect(data["transaction"]["amount"].to_f).to eq(120.5)
      expect(data["transaction"]["transactionType"]).to eq("expense")
      expect(data["transaction"]["category"]).to eq("groceries")
      expect(data["transaction"]["description"]).to eq("Zakupy w Lidlu")
    end
  end

  context "when invalid input is provided" do
    let(:variables) do
      {
        input: {
          userId: user.id,
          amount: -10, # Invalid amount
          transactionType: "invalid", # Invalid type
          category: nil, # Required when expense
          description: "Niepoprawna transakcja",
          date: "2025-06-01"
        }
      }
    end

    it "returns validation errors and no transaction" do
      post "/graphql",
        params: { query: mutation, variables: variables }.to_json,
        headers: { "Content-Type" => "application/json" }


      json = JSON.parse(response.body)
      data = json.dig("data", "createTransaction")

      expect(data["errors"]).not_to be_empty
      expect(data["transaction"]).to be_nil
    end
  end
end
