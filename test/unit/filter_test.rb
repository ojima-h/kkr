require 'test_helper'

class FilterTest < ActiveSupport::TestCase
  test "create" do
    filter = build(:filter)
    assert filter.save
  end

  test "should not save filter with empty condition and empty manipulation" do
    filter = build(:filter, :cond => "", :manipulations => [])
    assert !filter.save
  end
  test "shold not save filter with empty condition" do
    filter = build(:filter, :cond => "")
    assert !filter.save
  end
  # test "shold not save filter with empty manipulations" do
  #   filter = build(:filter, :manipulations => [])
  #   assert !filter.save
  # end

  test "should update manipulations" do
    filter = create(:filter)
    assert filter.update_manipulations([{:sort => "append",
                                          :object => "new_tag",
                                          :value => "new_value"}])
    assert !Manipulation.where(:filter_id => filter.id,
                                  :sort => "append",
                                  :object => "new_tag",
                                  :value => "new_value").empty?
  end

  test "should validation success" do
    assert Filter.validate({:content => "content"})
  end
end
