class User < ApplicationRecord
  has_secure_password

  has_many :transactions, dependent: :destroy

  validates :email, presence: true, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, message: "must be a valid email format" } # Sprawdzenie formatu emaila
  validates :password, length: { minimum: 6 }, allow_nil: true, format: { with: /[A-Z]/, message: "must contain at least one uppercase letter" } # Sprawdzenie dużej litery
  validates :password, format: { with: /[0-9]/, message: "must contain at least one digit" } # Sprawdzenie cyfry
  validates :password, format: { with: /[[:^alnum:]]/, message: "must contain at least one special character" } # Sprawdzenie znaku specjalnego
  validates :password_confirmation, presence: true, if: :password # Jeśli hasło jest podane, to musisz podać również potwierdzenie hasła
end
