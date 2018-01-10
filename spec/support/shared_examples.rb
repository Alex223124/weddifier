RSpec.shared_examples 'a logged out admin' do
  it 'redirects to admin login path' do
    get admin_logout_path
    action
    expect(response).to redirect_to admin_login_path
  end
end
