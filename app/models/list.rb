class List < ApplicationRecord
  # associations
  belongs_to :admin, class_name: 'User'

  # validations
  validates :title, presence: true
  validates :title, uniqueness: { scope: :admin_id }
  validate :user_role

  private

  def user_role
    errors.add(:base, 'Lists can be created by admins only') unless admin.admin?
  end
end
