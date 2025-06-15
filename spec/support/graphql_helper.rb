# spec/support/graphql_helper.rb

module GraphqlHelper
  def execute_mutation(query, variables: {}, context: {})
    post "/graphql", params: { query:, variables: }.to_json, headers: { "Content-Type": "application/json" }
    JSON.parse(response.body)
  end
  def execute_query(query, variables: {}, context: {})
  post "/graphql", params: { query:, variables: }.to_json, headers: { "Content-Type": "application/json" }
  JSON.parse(response.body)
  end
end

RSpec.configure do |config|
  config.include GraphqlHelper, type: :request
end
