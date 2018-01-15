# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Admin::Admin.create(email: 'admin@example.com', password: 'test')

200.times do
  Fabricate(:guest)
end

(1..50).each do |n|
  leader = Guest.find(n)
  plus_one = Guest.find(200 - n)

  leader.plus_one = plus_one
  leader.save
end
