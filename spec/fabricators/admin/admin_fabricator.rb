Fabricator(:admin, from: 'Admin::Admin') do
  email { Faker::Internet.email }
  password { 'password' }
end
