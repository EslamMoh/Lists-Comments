class CardDecorator < Draper::Decorator
  delegate_all

  def as_json(options = { comments: false })
    output = {
      id: id,
      title: title,
      description: description,
      created_at: created_at,
      updated_at: updated_at
    }

    output['cards'] = comments.limit(3).try(:decorate).try(:as_json) if options[:comments]
    output
  end
end
