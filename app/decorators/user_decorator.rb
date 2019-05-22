class UserDecorator < Draper::Decorator
  delegate_all

  def as_json(options = {})
    {
      id: id,
      name: name,
      email: email,
      role: role,
      created_at: created_at,
      updated_at: updated_at
    }
  end
end
