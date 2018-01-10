module ApplicationHelper
  def current_admin_path?
    path = request.env['PATH_INFO']
    !!(path == '/admin' || path == '/admin/login')
  end
end
