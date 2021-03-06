# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

DEFAULT_INSECURE_PASSWORD = ENV["ADMIN_PASSWORD"]

ActionMailer::Base.delivery_method = :test

User.create({
  first_name: "Eric",
  last_name: "Miller",
  profile_name: "theericmiller",
  email: "Eric@TheEricMiller.com",
  password: DEFAULT_INSECURE_PASSWORD
})

User.create({
  first_name: "Mike",
  last_name: "The Frog",
  profile_name: "mikethefrog",
  email: "mike@teamtreehouse.com",
  password: DEFAULT_INSECURE_PASSWORD,
  password_confirmation: DEFAULT_INSECURE_PASSWORD
})

User.create({
  first_name: "Jason",
  last_name: "Seifer",
  profile_name: "jason",
  email: "jason@teamtreehouse.com",
  password: DEFAULT_INSECURE_PASSWORD,
  password_confirmation: DEFAULT_INSECURE_PASSWORD
})

User.create({
  first_name: "Jim",
  last_name: "Hoskins",
  profile_name: "jim",
  email: "jim@teamtreehouse.com",
  password: DEFAULT_INSECURE_PASSWORD,
  password_confirmation: DEFAULT_INSECURE_PASSWORD
})

User.create({
  first_name: "Nick",
  last_name: "Pettit",
  profile_name: "nick",
  email: "nick@teamtreehouse.com",
  password: DEFAULT_INSECURE_PASSWORD,
  password_confirmation: DEFAULT_INSECURE_PASSWORD
})

User.create({
  first_name: "Ryan",
  last_name: "Carson",
  profile_name: "ryan",
  email: "ryan@teamtreehouse.com",
  password: DEFAULT_INSECURE_PASSWORD,
  password_confirmation: DEFAULT_INSECURE_PASSWORD
})

User.create({
  first_name: "Taco",
  last_name: "McArthur",
  profile_name: "TacoMcArthur",
  email: "taco@theleague.com",
  password: DEFAULT_INSECURE_PASSWORD,
  password_confirmation: DEFAULT_INSECURE_PASSWORD
})

admin_u = User.find_by_email('eric@theericmiller.com')
jason = User.find_by_email('jason@teamtreehouse.com')
jim   = User.find_by_email('jim@teamtreehouse.com')
nick  = User.find_by_email('nick@teamtreehouse.com')
mike  = User.find_by_email('mike@teamtreehouse.com')
ryan  = User.find_by_email('ryan@teamtreehouse.com')
taco  = User.find_by_email('taco@theleague.com')

seed_user = admin_u

seed_user.statuses.create(content: "Hello, MyFace!")
jim.statuses.create(content: "Hi, I'm Jim")
nick.statuses.create(content: "Hello from the internet!")
mike.statuses.create(content: "I want to learn html javapress")
ryan.statuses.create(content: "Gotta star this on Github...")
taco.statuses.create(content: "MyFace is awesome!")

UserFriendship.request(seed_user, taco).accept!
UserFriendship.request(seed_user, jim).accept!
UserFriendship.request(seed_user, nick).block!
UserFriendship.request(seed_user, mike)
UserFriendship.request(ryan, seed_user)


ActionMailer::Base.delivery_method = :smtp

User.get_gravatars

# ###############################################
