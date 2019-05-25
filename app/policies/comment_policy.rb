class CommentPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      return scope.all if user.admin?

      user.comments
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
