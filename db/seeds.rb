# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


User.create(
  email:'admin@example.com',
  name:'admin',
  location:nil,
  qq:123456,
  website:'',
  role:1,
  password:111111,
  password_confirmation:111111
)
p 'user admin create password is 111111'