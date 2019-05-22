class Card < ApplicationRecord
  # associations
  has_many :comments, as: :commentable
  belongs_to :user
  belongs_to :list

  # validations
  validates :title, :description, presence: true
  validates :title, uniqueness: { scope: :list_id }

  # scopes
  scope :most_common, -> { order('comments_count DESC') }
end
