require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @request.env["devise.mapping"] = Devise.mappings[:one]
    sign_in users(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
  end

end
