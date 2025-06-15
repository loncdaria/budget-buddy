require "rails_helper"

RSpec.describe "Users Query", type: :request do
  let!(:user1) { create(:user, email: "u1@example.com") }
  let!(:user2) { create(:user, email: "u2@example.com") }

  let(:query) do
    <<~GQL
      {
        testField
      }
    GQL
  end

  it "returns test field (placeholder)" do
   post "/graphql",
     params: { query: query }.to_json,
     headers: { "Content-Type" => "application/json" }


    json = JSON.parse(response.body)
    data = json.dig("data", "testField")

    expect(data).to be_a(String)
  end
end
