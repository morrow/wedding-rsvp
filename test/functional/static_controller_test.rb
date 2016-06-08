require 'test_helper'

class StaticControllerTest < ActionController::TestCase
  test "should get home" do
    get :home
    assert_response :success
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get information" do
    get :information
    assert_response :success
  end

  test "should get directions" do
    get :directions
    assert_response :success
  end

  test "should get accomodations" do
    get :accomodations
    assert_response :success
  end

  test "should get contact" do
    get :contact
    assert_response :success
  end

end
