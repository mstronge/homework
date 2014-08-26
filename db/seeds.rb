# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
10.times do |i|
  User.create(name: "student_#{i}", email: "student_#{i}@gmail.com", password: "12345678", confirm_password: "12345678", role: "student")
end
5.times do |i|
  User.create(name: "parent_#{i}", email: "parent_#{i}@gmail.com", password: "12345678", confirm_password: "12345678", role: "parent")
end
