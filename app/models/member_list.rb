class MemberList < ApplicationRecord
  # associations
  belongs_to :user
  belongs_to :list

  # validations
  validate :user_role
  validates :list_id, uniqueness: { scope: :user_id }

  private

  def user_role
    errors.add(:base, 'Lists can be assigned to members only') unless user.member?
  end
end
