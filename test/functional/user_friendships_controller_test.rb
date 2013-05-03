require 'test_helper'

class UserFriendshipsControllerTest < ActionController::TestCase
  
  context "#new" do
  	context "when not logged in" do
  		should "redirect to login page" do
  			get :new
  			assert_response :redirect
  		end
  	end

  	context "when logged in" do
  		setup do
  			sign_in users(:user1fix)
  		end

  		should "get new and return success" do
  			get :new
  			assert_response :success
  		end

  		should "should set a flash error if the friend_id param is missing" do 
  			get :new, {}
  			assert_equal "Friend required", flash[:error]
  		end

  		should "display the friend's name" do
  			get :new, friend_id: users(:user2fix).id 
  			assert_match /#{users(:user2fix).full_name}/, response.body 
  		end

  		should "assign a new user friendship" do
  			get :new, friend_id: users(:user2fix).id
  			assert assigns(:user_friendship)
  		end

  		should "assign a new user friendship to correct friend" do
  			get :new, friend_id: users(:user2fix).id
  			assert_equal users(:user2fix), assigns(:user_friendship).friend
  		end

  		should "assign a new user friendship to currently logged in user" do
  			get :new, friend_id: users(:user2fix).id
  			assert_equal users(:user1fix), assigns(:user_friendship).user
  		end

  		should "return a 404 status if no friend is found" do
  			get :new, friend_id: 'invalid'
  			assert_response :not_found
  		end

  	end
  end

end
