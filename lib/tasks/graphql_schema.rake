# lib/tasks/graphql_schema.rake
namespace :graphql do
  desc "Print GraphQL Schema in SDL format"
  task print_schema: :environment do
    schema = BudgetBuddySchema.to_definition
    File.write("graphql_schema.graphql", schema)
    puts "GraphQL schema has been written to graphql_schema.graphql"
  end
end
