desc "Import avatars from a user's gravatar URL"
task :import_avatars => :environment do
  User.get_gravatars
end