require "rails_helper"

RSpec.describe "Transactions Queries", type: :request do
  let(:user) { create(:user) }

  let!(:transaction_1) do
    create(:transaction, user:, amount: 50.0, transaction_type: "expense", category: "food", date: Date.today.beginning_of_month + 1.day)
  end

  let!(:transaction_2) do
    create(:transaction, user:, amount: 150.0, transaction_type: "income", category: "salary", date: Date.today.beginning_of_month + 5.days)
  end

  let(:start_date) { Date.today.beginning_of_month }
  let(:end_date)   { Date.today.end_of_month }

  it "returns all transactions for the user" do
    query = <<~GQL
      query($userId: ID!) {
        transactions(userId: $userId) {
          id
          amount
          transactionType
          category
        }
      }
    GQL

    post "/graphql",
         params: {
           query: query,
           variables: { userId: user.id }
         }.to_json,
         headers: { "Content-Type" => "application/json" }

    json = JSON.parse(response.body)
    data = json.dig("data", "transactions")

    expect(data.count).to eq(2)
  end

  it "returns total transactions amount" do
    query = <<~GQL
      query($userId: ID!, $startDate: ISO8601Date!, $endDate: ISO8601Date!) {
        totalTransactions(userId: $userId, startDate: $startDate, endDate: $endDate)
      }
    GQL

    post "/graphql",
         params: {
           query: query,
           variables: {
             userId: user.id,
             startDate: start_date,
             endDate: end_date
           }
         }.to_json,
         headers: { "Content-Type" => "application/json" }

    json = JSON.parse(response.body)
    amount = json.dig("data", "totalTransactions")

    expect(amount.to_f).to eq(200.0)
  end

  it "returns total income only" do
    query = <<~GQL
      query($userId: ID!, $transactionType: String!, $startDate: ISO8601Date!, $endDate: ISO8601Date!) {
        totalTransactionsByType(
          userId: $userId,
          transactionType: $transactionType,
          startDate: $startDate,
          endDate: $endDate
        )
      }
    GQL

    post "/graphql",
         params: {
           query: query,
           variables: {
             userId: user.id,
             transactionType: "income",
             startDate: start_date,
             endDate: end_date
           }
         }.to_json,
         headers: { "Content-Type" => "application/json" }

    json = JSON.parse(response.body)
    result = json.dig("data", "totalTransactionsByType")

    expect(result.to_f).to eq(150.0)
  end

  it "returns average transaction amount for a type" do
    query = <<~GQL
      query($userId: ID!, $transactionType: String!, $startDate: ISO8601Date!, $endDate: ISO8601Date!) {
        averageTransactionAmount(
          userId: $userId,
          transactionType: $transactionType,
          startDate: $startDate,
          endDate: $endDate
        )
      }
    GQL

    post "/graphql",
         params: {
           query: query,
           variables: {
             userId: user.id,
             transactionType: "expense",
             startDate: start_date,
             endDate: end_date
           }
         }.to_json,
         headers: { "Content-Type" => "application/json" }

    json = JSON.parse(response.body)
    value = json.dig("data", "averageTransactionAmount")

    expect(value.to_f).to eq(50.0)
  end

  it "returns transaction count in date range" do
    query = <<~GQL
      query($userId: ID!, $startDate: ISO8601Date!, $endDate: ISO8601Date!) {
        transactionCount(
          userId: $userId,
          startDate: $startDate,
          endDate: $endDate
        )
      }
    GQL

    post "/graphql",
         params: {
           query: query,
           variables: {
             userId: user.id,
             startDate: start_date,
             endDate: end_date
           }
         }.to_json,
         headers: { "Content-Type" => "application/json" }

    json = JSON.parse(response.body)
    count = json.dig("data", "transactionCount")

    expect(count).to eq(2)
  end

  it "returns total expenses by category" do
    query = <<~GQL
      query($userId: ID!, $category: String!, $startDate: ISO8601Date!, $endDate: ISO8601Date!) {
        totalExpensesByCategory(
          userId: $userId,
          category: $category,
          startDate: $startDate,
          endDate: $endDate
        )
      }
    GQL

    post "/graphql",
         params: {
           query: query,
           variables: {
             userId: user.id,
             category: "food",
             startDate: start_date,
             endDate: end_date
           }
         }.to_json,
         headers: { "Content-Type" => "application/json" }

    json = JSON.parse(response.body)
    result = json.dig("data", "totalExpensesByCategory")

    expect(result.to_f).to eq(50.0)
  end
end
