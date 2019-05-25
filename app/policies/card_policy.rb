class CardPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      user.cards
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
