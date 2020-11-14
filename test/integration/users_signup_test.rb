require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  # Clear the email buffer for testing
  def setup
    ActionMailer::Base.deliveries.clear
  end

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
          name: "Example user",
          email: "user@example.com",
          password: "foobar",
          password_confirmation: "foobar"
        }
      }
    end
    assert_equal(1, ActionMailer::Base.deliveries.size)
    user = assigns(:user)
    assert_not user.activated?
    # Try to login before activation!
    log_in_as user
    assert_not is_logged_in?
    # Test for entering an invalid activation token
    get edit_account_activation_path(id: "invalid token", email: user.email)
    assert_not is_logged_in?
    # Valid activation
    get edit_account_activation_path(id: user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show' 
    assert is_logged_in?
  end

end