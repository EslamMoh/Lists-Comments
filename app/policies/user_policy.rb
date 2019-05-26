class UserPolicy < ApplicationPolicy
  def index?
    return true if user.admin?

    false
  end

  def show?
    true
  end
end
