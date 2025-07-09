FactoryBot.define do
  factory :transaction do
    association :user
    amount { 100.0 }
    transaction_type { "expense" }
    category { "office_supplies" }
    description { "Opis" }
    date { Date.today }
  end
end
