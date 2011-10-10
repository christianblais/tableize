# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

NAMES = %w(John William Scott Ted Harry Stephen Christian Matthiew Arthur Greg Catherine)

10.times do |i|
  Post.create(:title => "Post ##{i}", :author => NAMES.sample, :time => Time.now - rand(100).minutes)
end