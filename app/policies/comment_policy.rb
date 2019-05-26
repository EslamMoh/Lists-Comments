class CommentPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      return scope.all if user.admin?

      Comment.where(commentable: Card.where(list_id: user.assigned_lists.pluck(:id)))
    end

    def comments_and_replies_scope
      return scope.all if user.admin?

      Comment.where(commentable: Card.where(list_id: user.assigned_lists.pluck(:id)) +
      Comment.where(commentable: Card.where(list_id: user.assigned_lists.pluck(:id))))
    end

    def update_and_remove_scope
      if user.admin?
        (Comment.where(commentable: Card.where(list_id: user.lists.pluck(:id)) +
         Comment.where(commentable: Card.where(list_id: user.lists.pluck(:id)))) +
         Comment.where(user_id: user.id)).uniq
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
