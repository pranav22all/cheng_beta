require 'test_helper'

class CurrentPagesControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get current_pages_home_url
    assert_response :success
  end

  test "should get aboutus" do
    get current_pages_aboutus_url
    assert_response :success
  end

  test "should get ourwork" do
    get current_pages_ourwork_url
    assert_response :success
  end

end
