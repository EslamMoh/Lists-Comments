class CardPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      user.cards
    end

    def users_scope
      return scope.where(list_id: List.pluck(:id)) if user.admin?

      scope.where(list_id: user.assigned_lists.pluck(:id))
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
