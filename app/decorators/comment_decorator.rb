class CommentDecorator < Draper::Decorator
  delegate_all

  def as_json(options = { replies: false })
    output = {
      id: id,
      content: content,
      created_at: created_at,
      updated_at: updated_at
    }

    output['replies'] = replies.try(:decorate).try(:as_json) if options[:replies]
    output
  end
end
