desc "Import avatars from a user's gravatar URL"
task :import_avatars => :environment do
  puts "Importing avatars from gravatar"
  User.get_gravatars
  puts "Avatars Updated."
end