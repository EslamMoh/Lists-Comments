class User < ApplicationRecord
  # encrypt password
  has_secure_password

  # associations
  has_many :lists, class_name: 'List', foreign_key: 'admin_id'

  # enums
  enum role: %i[admin member]

  # validations
  validates :name, :email, :password_digest, :role, presence: true
  validates :email, uniqueness: { scope: :role }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP,
                              message: 'only allows valid emails' }
end
