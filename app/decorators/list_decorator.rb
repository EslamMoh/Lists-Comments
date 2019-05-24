class ListDecorator < Draper::Decorator
  delegate_all

  def as_json(options = { cards: false, admin: false })
    output = {
      id: id,
      title: title,
      created_at: created_at,
      updated_at: updated_at
    }

    output['cards'] = cards.most_common.try(:decorate).try(:as_json) if options[:cards]
    output['admin'] = admin.try(:decorate).try(:as_json) if options[:admin]
    output
  end
end
