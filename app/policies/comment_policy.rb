class CommentPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      return scope.all if user.admin?

      Comment.where(commentable: Card.where(list_id: user.assigned_lists.pluck(:id)))
    end

    def comments_and_replies_scope
      return scope.all if user.admin?

      cards_ids = Card.where(list_id: user.assigned_lists.pluck(:id)).pluck(:id)
      Comment.where("(commentable_id IN (:card_ids) AND commentable_type = 'Card') OR (commentable_id IN (:comment_ids) AND commentable_type = 'Comment')", 
                    card_ids: cards_ids,
                    comment_ids: Comment.where(commentable: cards_ids).pluck(:id))
    end

    def update_and_remove_scope
      if user.admin?
        cards_ids = Card.where(list_id: user.lists.pluck(:id)).pluck(:id)
        Comment.where("(commentable_id IN (:card_ids) AND commentable_type = 'Card') OR (commentable_id IN (:comment_ids) AND commentable_type = 'Comment') OR user_id = :user_id", 
                      card_ids: cards_ids,
                      comment_ids: Comment.where(commentable: cards_ids).pluck(:id),
                      user_id: user.id).distinct(:id)
      else
        user.comments
      end
    end
  end

  def index?
    true
  end

  def show?
    true
  end

  def update?
    true
  end

  def create?
    true
  end

  def destroy?
    true
  end
end
