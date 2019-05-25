class CardPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      user.cards
    end

    def users_scope
      return scope.where(list_id: List.select(:id)) if user.admin?

      scope.where(list_id: user.assigned_lists.select(:id))
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
