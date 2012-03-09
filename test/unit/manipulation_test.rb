require 'test_helper'

class ManipulationTest < ActiveSupport::TestCase
  setup do
    @filter = create(:filter)
  end
  
  # test "the truth" do
  #   assert true
  # end
  test "create" do
    manipulation = build(:manipulation)
    manipulation.filter = @filter
    assert manipulation.save
  end

  test "should not have nil value for each attribute" do
    # sort is not defined
    m1 = Manipulation.new(attributes_for(:manipulation, :sort => nil))
    m1.filter = @filer
    assert !m1.save

    # object is not defined
    m2 = Manipulation.new(attributes_for(:manipulation, :object => nil))
    m2.filter = @filter
    assert !m2.save
  end

  test "should have empty string as defalut value" do
    manipulation = Manipulation.new(attributes_for(:manipulation, :value => nil))
    manipulation.filter = create(:filter)

    assert manipulation.save
    assert_equal manipulation.value, ""
  end

  test "should not have invalid sort" do
    manipulation = build(:manipulation, :sort => "dummy")
    manipulation.filter = create(:filter)
    assert !manipulation.save
  end
end
