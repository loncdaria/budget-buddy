# spec/factories/transactions.rb
FactoryBot.define do
  factory :transaction do
    association :user
    amount { 100.0 }
    transaction_type { "expense" }
    category { "office_supplies" }
    description { "Domyślny opis" }
    date { Date.today }
  end
end
