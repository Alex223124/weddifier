module Admin::IndexHelper
  def admin_filter(attribute)
    name = to_filter_name(attribute)

    if params[:order].blank? || params[:order] == 'desc'
      link_to name, admin_path(query: attribute, order: 'asc')
    elsif params[:order] == 'asc'
      link_to name, admin_path(query: attribute, order: 'desc')
    end
  end

  def to_filter_name(attribute)
    first, last = attribute.split('_')
    [first.capitalize, last].join(' ')
  end
end
