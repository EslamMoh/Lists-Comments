class ListDecorator < Draper::Decorator
  delegate_all

  def as_json(options = { cards: false })
    output = {
      id: id,
      title: title,
      created_at: created_at,
      updated_at: updated_at
    }

    output['cards'] = cards.try(:decorate).try(:as_json) if options[:cards]
    output
  end
end
