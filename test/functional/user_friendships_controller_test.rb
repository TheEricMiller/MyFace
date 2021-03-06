require 'test_helper'

class UserFriendshipsControllerTest < ActionController::TestCase
  context "#index" do
    context "when not logged in" do
      should "redirect to login page" do
        get :index
        assert_response :redirect
      end
    end

    context "when logged in" do
      setup do
        @friendship1 = create(:pending_user_friendship, user: users(:user1fix), friend: create(:user, first_name: "Pending", last_name: "Friend"))    
        @friendship2 = create(:accepted_user_friendship, user: users(:user1fix), friend: create(:user, first_name: "Active", last_name: "Friend"))
        @friendship3 = create(:requested_user_friendship, user: users(:user1fix), friend: create(:user, first_name: "Requested", last_name: "Friend"))
        @friendship4 = user_friendships(:blocked_by_user1fix)
        
        sign_in users(:user1fix)
        get :index
      end

      should "get the index page without error" do
        assert_response :success
      end

      should "assign user friendships" do
        assert assigns(:user_friendships)
      end

      should "display friend's names" do
        assert_match /Pending/, response.body
        assert_match /Active/, response.body
      end

      should "display pending information on a pending friendship" do
        assert_select "#user_friendship_#{@friendship1.id}" do
          assert_select "em", "Friendship Pending"
        end
      end

      should "display date information on am accepted friendship" do
        assert_select "#user_friendship_#{@friendship2.id}" do
          assert_select "em", "Friends Since #{@friendship2.updated_at}"
        end
      end

  context "blocked users" do
        setup do
          get :index, list: 'blocked'
        end

        should "get the index without error" do
          assert_response :success
        end

        should "not display pending or active friend's names" do
          assert_no_match /Pending\ Friend/, response.body
          assert_no_match /Active\ Friend/, response.body
        end

        should "display blocked friend names" do
          assert_match /Blocked\ Friend/, response.body
        end
      end

context "pending friendships" do
        setup do
          get :index, list: 'pending'
        end

        should "get the index without error" do
          assert_response :success
        end

        should "not display pending or active friend's names" do
          assert_no_match /Blocked\ Friend/, response.body
          assert_no_match /Active\ Friend/, response.body
        end

        should "display pending friend names" do
          assert_match /Pending\ Friend/, response.body
        end
      end

context "requested friendships" do
        setup do
          get :index, list: 'requested'
        end

        should "get the index without error" do
          assert_response :success
        end

        should "not display pending or active friend's names" do
          assert_no_match /Blocked\ Friend/, response.body
          assert_no_match /Active\ Friend/, response.body
        end

        should "display requested friend names" do
          assert_match /Requested\ Friend/, response.body
        end
      end

context "accepted friendships" do
        setup do
          get :index, list: 'accepted'
        end

        should "get the index without error" do
          assert_response :success
        end

        should "not display pending or active friend's names" do
          assert_no_match /Pending\ Friend/, response.body
          assert_no_match /Blocked\ Friend/, response.body
        end

        should "display accepted friend names" do
          assert_match /Active\ Friend/, response.body
        end
      end


    end
  end


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
  			get :new, friend_id: users(:user2fix)
  			assert_match /#{users(:user2fix).full_name}/, response.body 
  		end

  		should "assign a new user friendship" do
  			get :new, friend_id: users(:user2fix)
  			assert assigns(:user_friendship)
  		end

  		should "assign a new user friendship to correct friend" do
  			get :new, friend_id: users(:user2fix)
  			assert_equal users(:user2fix), assigns(:user_friendship).friend
  		end

  		should "assign a new user friendship to currently logged in user" do
  			get :new, friend_id: users(:user2fix)
  			assert_equal users(:user1fix), assigns(:user_friendship).user
  		end

  		should "return a 404 status if no friend is found" do
  			get :new, friend_id: 'invalid'
  			assert_response :not_found
  		end

      should "ask if you really want to friend the user" do
        get :new, friend_id: users(:user2fix)
        assert_match /Do you really want to friend #{users(:user2fix).full_name}?/, response.body
      end

  	end
  end


  context "#create" do
    context "when not logged in" do
      should "redirect to the login page" do
        get :new
        assert_response :redirect
        assert_redirected_to sign_in_path
      end
    end

    context "when logged in" do
      setup do
        sign_in users(:user1fix)
      end

      context "with no friend_id" do
        setup do
          post :create
        end

        should "set the flash error message" do
          assert !flash[:error].empty?
        end

        should "redirect to root path" do 
          assert_redirected_to root_path
        end
      end

      context "successfully" do
        should "create two user friendship objects" do
          assert_difference 'UserFriendship.count', 2 do
            post :create, user_friendship: { friend_id: users(:mike).profile_name }
          end
        end
      end

      context "with a valid friend_id" do
        setup do
          post :create, user_friendship: { friend_id: users(:mike).profile_name }
        end

        should "assign a friend object" do
          assert assigns(:friend)
          assert_equal users(:mike), assigns(:friend)
        end

        should "assign a user_friendship object" do
          assert assigns(:user_friendship)
          assert_equal users(:user1fix), assigns(:user_friendship).user
          assert_equal users(:mike), assigns(:user_friendship).friend
        end

        should "create a friendship" do
          assert users(:user1fix).pending_friends.include?(users(:mike))
        end

        should "redirect to the profile page of the friend" do
          assert_response :redirect
          assert_redirected_to profile_path(users(:mike))
        end

        should "set the flash success message" do
          assert flash[:success]
          assert_equal "Friend request sent.", flash[:success]
        end
      end

    end
  end

  context "#accept" do
    context "when not logged in" do
      should "redirect to the login page" do
        put :accept, id: 1
        assert_response :redirect
        assert_redirected_to sign_in_path
      end
    end

    context "when logged in" do
      setup do
        @friend = create(:user)
        @user_friendship = create(:pending_user_friendship, user: users(:user1fix), friend: @friend)
        create(:pending_user_friendship, friend: users(:user1fix), user: @friend)
        sign_in users(:user1fix)
        put :accept, id: @user_friendship
        @user_friendship.reload
      end

      should "assign a user_friendship" do
        assert assigns(:user_friendship)
        assert_equal @user_friendship, assigns(:user_friendship)
      end

      should "update the state to accepted" do
        assert_equal 'accepted', @user_friendship.state
      end

      should "have a flash success message" do
        assert_equal "You are now friends with #{@user_friendship.friend.first_name}", flash[:success]
      end
    end
  end


  context "#edit" do
    context "when not logged in" do
      should "redirect to login page" do
        get :edit, id: 1
        assert_response :redirect
      end
    end

    context "when logged in" do
      setup do
        @user_friendship = create(:pending_user_friendship, user: users(:user1fix))
        sign_in users(:user1fix)
        get :edit, id: @user_friendship.friend.profile_name
      end

      should "get edit and return success" do
        assert_response :success
      end

      should "assign to user_friendship" do
        assert assigns(:user_friendship)
      end

      should "assign to friend" do
        assert assigns(:friend)
      end
    end
  end


  context "#destroy" do
    context "when not logged in" do
      should "redirect to the login page" do
        delete :destroy, id: 1
        assert_response :redirect
        assert_redirected_to sign_in_path
      end
    end

    context "when logged in" do
      setup do
        @friend = create(:user)
        @user_friendship = create(:accepted_user_friendship, friend: @friend, user: users(:user1fix))
        create(:accepted_user_friendship, friend: users(:user1fix), user: @friend)
        
        sign_in users(:user1fix)
      end

      should "delete user friendships" do
        assert_difference 'UserFriendship.count', -2 do
          delete :destroy, id: @user_friendship
        end
      end

      should "set the flash" do
        delete :destroy, id: @user_friendship
        assert_equal "Friendship destroyed", flash[:success]
      end
    end
  end

  context "#block" do
    context "when not logged in" do
      should "redirect to the login page" do
        put :block, id: 1
        assert_response :redirect
        assert_redirected_to sign_in_path
      end
    end

    context "when logged in" do
      setup do
        @user_friendship = create(:pending_user_friendship, user: users(:user1fix))
        sign_in users(:user1fix)
        put :block, id: @user_friendship
        @user_friendship.reload
      end

      should "assign a user friendship" do
        assert assigns(:user_friendship)
        assert_equal @user_friendship, assigns(:user_friendship)
      end

      should "update the user friendship state to blocked" do
        assert_equal 'blocked', @user_friendship.state
      end
    end
  end



end






