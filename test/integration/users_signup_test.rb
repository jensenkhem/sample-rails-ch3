require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "invalid signup does not go through" do
    get signup_path
    assert_no_difference 'User.count' do
      post signup_path, params: { 
        user: { 
          name: "",
          email: "user@invalid",
          password: "foobar",
          password_confirmation: "barfoo"
        }
      }
    end
    assert_template 'users/new' 
    assert_select "div#error_explanation"
    assert_select "div.field_with_errors"
  end

  test "vaild signup" do
    get signup_path
    assert_difference 'User.count', 1 do
      post signup_path, params: { 
        user: { 
          name: "Example",
          email: "user@vaild.com",
          password: "foobar",
          password_confirmation: "foobar"
        }
      }
    end
    follow_redirect!
    assert_template 'users/show' 
    assert_not flash.empty?
  end

end