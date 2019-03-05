# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
user = User.find_by login: 'longsheng'
unless user.present?
  User.create login: 'longsheng', password: '12345678', title: '系统管理', name: '龙胜', email: 'longsheng@longsheng.com'
end
Role.load!
Resource.load!
