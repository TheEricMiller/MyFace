require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "a user should enter a first name" do
  	user = User.new
  	assert !user.save
  	assert !user.errors[:first_name].empty?
  end

  test "a user should enter a last name" do
  	user = User.new
  	assert !user.save
  	assert !user.errors[:last_name].empty?
  end

  test "a user should enter a profile name" do
  	user = User.new
  	assert !user.save
  	assert !user.errors[:profile_name].empty?
  end

  test "a user should have a unique profile name" do
  	user = User.new
  	user.email = 'AgentJ@test.com'
  	user.profile_name = 'AgentJ'
  	user.first_name = 'Jimmy'
  	user.last_name = 'John'
  	user.password = 'password123'
  	user.save

  	user = User.new
  	user.email = 'AgentZ@test.com'
  	user.profile_name = 'AgentJ'
  	user.first_name = 'Jazz'
  	user.last_name = 'Jacobs'
  	user.password = 'password123'
  	assert !user.save
  	#puts user.errors.inspect
  	assert !user.errors[:profile_name].empty?
  end

end
