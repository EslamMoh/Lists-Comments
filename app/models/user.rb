class User < ApplicationRecord
  # encrypt password
  has_secure_password

  # associations
  has_many :lists, foreign_key: 'admin_id'
  has_many :member_lists, dependent: :destroy
  has_many :assigned_lists, through: :member_lists, source: :list

  # enums
  enum role: %i[admin member]

  # validations
  validates :name, :password_digest, :role, presence: true
  validates :email, uniqueness: { scope: :role },
                    presence: true,
                    format: { with: URI::MailTo::EMAIL_REGEXP,
                              message: 'only allows valid emails' }
end
