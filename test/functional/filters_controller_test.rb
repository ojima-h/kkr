require 'test_helper'

class FiltersControllerTest < ActionController::TestCase
  setup do
    #@filter = filters(:one)
    @filter = create(:filter)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:filters)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create filter" do
    assert_difference('Filter.count') do
      post :create, filter: @filter.attributes
    end
    
    assert_redirected_to filter_path(assigns(:filter))
  end

  test "should show filter" do
    get :show, id: @filter.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @filter.to_param
    assert_response :success
  end

  test "should update filter" do
    put :update, id: @filter.to_param, filter: @filter.attributes
    assert_redirected_to filter_path(assigns(:filter))
  end

  test "should destroy filter" do
    assert_difference('Filter.count', -1) do
      delete :destroy, id: @filter.to_param
    end

    assert_redirected_to filters_path
  end
end
