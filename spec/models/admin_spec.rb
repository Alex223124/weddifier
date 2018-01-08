require 'rails_helper'

describe Admin::Admin, type: :model do
  it { should have_secure_password }
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should validate_length_of(:password).is_at_least(4) }
end
