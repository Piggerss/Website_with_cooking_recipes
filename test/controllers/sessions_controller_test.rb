require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "admin pages require a signed-in session" do
    get admin_recipes_url

    assert_redirected_to login_url
  end

  test "correct credentials grant access to the admin panel" do
    post login_url, params: { login: "admin", password: "admin" }

    assert_redirected_to admin_recipes_url
    get admin_recipes_url
    assert_response :success
  end

  test "incorrect credentials render the login form with an error" do
    post login_url, params: { login: "admin", password: "wrong" }

    assert_response :unprocessable_content
    assert_select ".form-errors", text: /Неверный логин или пароль/
  end

  test "logout ends access to the admin panel" do
    post login_url, params: { login: "admin", password: "admin" }
    post logout_url

    assert_redirected_to root_url
    get admin_recipes_url
    assert_redirected_to login_url
  end
end
