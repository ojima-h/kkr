require 'test_helper'

class ManipulationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "create" do
    manipulation = Manipulation.new(:sort => "append",
                                    :object => "tag_name",
                                    :value => "link_value")
    manipulation.filter = filters(:one)
    assert manipulation.save
  end

  test "should not have nil value for each attribute" do
    f = filters(:one)
    # sort is not defined
    m1 = Manipulation.new(:object => "tag_name",
                          :value => "link_value")
    m1.filter = f
    assert !m1.save
    # object is not defined
    m2 = Manipulation.new(:sort => "append",
                          :value => "link_value")
    m2.filter = f
    assert !m2.save
    # #filter_id is not defined
    # m3 = Manipulation.new(:sort => "append",
    #                       :object => "tag_name",
    #                       :value => "link_value")
    # assert !m3.save
  end

  test "should have empty string as defalut value" do
    manipulation = Manipulation.new(:sort => "append",
                                    :object => "tag_name")
    manipulation.filter = filters(:one)
    assert_equal manipulation.value, ""
    assert manipulation.save
  end

  test "should not have invalid sort" do
    manipulation = Manipulation.new(:sort => "dummy",
                                    :object => "tag_name")
    manipulation.filter = filters(:one)
    assert !manipulation.save
  end
end
