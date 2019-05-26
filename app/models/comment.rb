class Comment < ApplicationRecord
  # associations
  has_many :replies, class_name: 'Comment', as: :commentable,
                     dependent: :destroy
  belongs_to :commentable, polymorphic: true
  belongs_to :user

  # validations
  validates :content, presence: true
  validate  :commentable_reply
  # callbacks
  after_create -> { update_comments_counter('increment') }, if: -> { commentable.is_a? Card }
  before_destroy -> { update_comments_counter('decrement') }, if: -> { commentable.is_a? Card }

  private

  def update_comments_counter(operation)
    comments_count = commentable.comments_count
    return if comments_count.zero?

    if operation == 'increment'
      commentable.update(comments_count: comments_count + 1)
      return
    end
    commentable.update(comments_count: comments_count - 1)
  end

  def commentable_reply
    errors.add(:base, 'You cannot reply to another reply.') if commentable_type == 'Comment'
  end
end
