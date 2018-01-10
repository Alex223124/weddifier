def admin_login
  admin = Fabricate(:admin)
  post admin_login_path, params: { email: admin.email, password: admin.password }
end
