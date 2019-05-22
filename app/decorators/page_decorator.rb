class PageDecorator < Draper::Decorator
  delegate_all

  def as_json(options = {})
    {
      page: current_page,
      records_per_page: model.count,
      total: total_count,
      records: model.decorate.as_json(options)
    }
  end
end
