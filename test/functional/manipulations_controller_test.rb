require 'test_helper'

class ManipulationsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @request.env["devise.mapping"] = Devise.mappings[:one]
    sign_in users(:one)
  end

  # test "the truth" do
  #   assert true
  # end
end
