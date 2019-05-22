class Card < ApplicationRecord
  # associations
  belongs_to :user
  belongs_to :list

  # validations
  validates :title, :description, presence: true
  validates :title, uniqueness: { scope: :list_id }
end
