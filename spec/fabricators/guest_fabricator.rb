Fabricator(:guest) do
  first_name { Faker::Name.first_name }
  last_name { Faker::Name.last_name }
  father_surname { Faker::Name.last_name }
  mother_surname { Faker::Name.last_name }
  email { Faker::Internet.email }
  phone { 10.times.map{rand(1..9)}.join }
end
