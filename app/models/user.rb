class User < ApplicationRecord
  # encrypt password
  has_secure_password

  # enums
  enum role: %i[admin member]

  # Validations
  validates :name, :email, :password_digest, :role, presence: true
  validates :email, uniqueness: { scope: :role }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP,
                              message: 'only allows valid emails' }
end
