class ListPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      return scope.all if user.admin?

      user.assigned_lists
    end

    def users_scope
      return user.lists if user.admin?

      user.assigned_lists
    end
  end

  def index?
    true
  end

  def show?
    true
  end

  def update?
    user_validation
  end

  def create?
    user_validation
  end

  def destroy?
    user_validation
  end

  def assign_member?
    user_validation
  end

  def unassign_member?
    user_validation
  end

  def user_validation
    return true if user.admin?

    false
  end
end
