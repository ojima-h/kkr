require 'test_helper'

class RestrictionsControllerTest < ActionController::TestCase
  setup do
    @restriction = restrictions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:restrictions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create restriction" do
    assert_difference('Restriction.count') do
      post :create, restriction: @restriction.attributes
    end

    assert_redirected_to restriction_path(assigns(:restriction))
  end

  test "should show restriction" do
    get :show, id: @restriction.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @restriction.to_param
    assert_response :success
  end

  test "should update restriction" do
    put :update, id: @restriction.to_param, restriction: @restriction.attributes
    assert_redirected_to restriction_path(assigns(:restriction))
  end

  test "should destroy restriction" do
    assert_difference('Restriction.count', -1) do
      delete :destroy, id: @restriction.to_param
    end

    assert_redirected_to restrictions_path
  end
end
