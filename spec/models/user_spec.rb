require "rails_helper"

RSpec.describe User, type: :model do
  subject(:user) { build(:user) }

  describe "validations" do
    context "when attributes are valid" do
      it { is_expected.to be_valid }
    end

    context "email validations" do
      it { is_expected.to validate_presence_of(:email) }
      it { is_expected.to allow_value("user@example.com").for(:email) }
      it { is_expected.not_to allow_value("invalid_email").for(:email) }
    end

    context "password validations" do
      it { is_expected.to validate_length_of(:password).is_at_least(6) }

      it "requires special character in password" do
        user.password = "Test123"
        user.password_confirmation = "Test123"
        expect(user).not_to be_valid
        expect(user.errors[:password]).to include("must contain at least one special character")
      end
    end
  end

  describe "associations" do
    it { is_expected.to have_many(:transactions).dependent(:destroy) }

    context "when user is destroyed" do
      let(:user) { create(:user) }
      let!(:transaction) { create(:transaction, user: user) }

      it "removes associated transactions" do
        expect { user.destroy }.to change(Transaction, :count).by(-1)
      end
    end
  end
end
