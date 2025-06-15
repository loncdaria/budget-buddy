require "rails_helper"

RSpec.describe Transaction, type: :model do
  describe "validations" do
    it "is valid with valid attributes" do
      transaction = build(:transaction)
      expect(transaction).to be_valid
    end

    it "is invalid without amount" do
      transaction = build(:transaction, amount: nil)
      expect(transaction).not_to be_valid
    end

    it "is invalid with negative amount" do
      transaction = build(:transaction, amount: -5)
      expect(transaction).not_to be_valid
    end

    it "is invalid without transaction_type" do
      transaction = build(:transaction, transaction_type: nil)
      expect(transaction).not_to be_valid
    end

    it "is invalid with invalid transaction_type" do
      transaction = build(:transaction, transaction_type: "invalid")
      expect(transaction).not_to be_valid
    end

    it "is invalid without category if type is expense" do
      transaction = build(:transaction, transaction_type: "expense", category: nil)
      expect(transaction).not_to be_valid
    end

    it "is valid without category if type is income" do
      transaction = build(:transaction, transaction_type: "income", category: nil)
      expect(transaction).to be_valid
    end

    it "is invalid without date" do
      transaction = build(:transaction, date: nil)
      expect(transaction).not_to be_valid
    end
  end

  describe "associations" do
    it { is_expected.to belong_to(:user) }
  end
end
