class UserNotifier < ActionMailer::Base
  default from: ENV["ACT_MAILER_FROM_DEFAULT_ADDRESS"]

  def friend_requested(user_friendship_id)
  	user_friendship = UserFriendship.find(user_friendship_id)

  	@user = user_friendship.user
  	@friend = user_friendship.friend 

  	mail to: @friend.email,
  		subject: "#{@user.first_name} wants to be a friend on MyFace"
  end

  def friend_request_accepted(user_friendship_id)
  	user_friendship = UserFriendship.find(user_friendship_id)

  	@user = user_friendship.user
  	@friend = user_friendship.friend 

  	mail to: @friend.email,
  		subject: "#{@user.first_name} has accepted your friend request on MyFace"
  end

end
