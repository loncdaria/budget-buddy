require "rails_helper"
RSpec.describe "TestField Query", type: :request do
  it "returns Hello World!" do
      query = <<~GQL
      query {
        testField
    }
      GQL

post "/graphql",
         params: { query: query }.to_json,
         headers: { "Content-Type" => "application/json" }

    json = JSON.parse(response.body)
    data = json.dig("data", "testField")

    expect(data).to eq("Hello World!")
  end
end
