RSpec.shared_examples 'a logged out admin' do
  it 'redirects to admin login path' do
    get admin_logout_path
    action
    expect(response).to redirect_to admin_login_path
  end
end

RSpec.shared_examples 'trying to register twice' do
  before do
    action
  end

  it 'flashes an error message' do
    expect(flash[:danger]).to be_present
  end

  it 'redirects to root path' do
    expect(response).to redirect_to root_path
  end
end

RSpec.shared_examples 'trying to register a plus one without a leader' do
  before do
    action
  end

  it 'flashes an error message' do
    expect(flash[:danger]).to be_present
  end

  it 'redirects to root path' do
    expect(response).to redirect_to root_path
  end
end

RSpec.shared_examples 'trying to register a plus one twice' do
  before do
    leader = post_valid_guest_with_plus_one_option
    post_valid_plus_one(leader)
    action
  end

  it 'flashes an error' do
    expect(flash[:danger]).to be_present
  end

  it 'redirects to root path' do
    expect(response).to redirect_to root_path
  end
end
