class List < ApplicationRecord
  # associations
  belongs_to :admin, -> { where role: 'admin' }, class_name: 'User'
  has_many :member_lists, dependent: :destroy
  has_many :members, -> { where role: 'member' }, through: :member_lists,
                                                  source: :user
  has_many :cards, dependent: :destroy
  has_many :comments, through: :cards

  # validations
  validates :title, presence: true
  validates :title, uniqueness: { scope: :admin_id }
end
