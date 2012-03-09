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
    assert Filter.validate(:content => "content")
  end

  test "should validate by tag name" do
    Filter.all.each {|f| f.destroy}
    f1 = create(:filter, :cond => "tag_name1 and tag_name2")
    f2 = create(:filter, :cond => "tag_name0")

    filters = Filter.validate(:contet => "content",
                              :links => [{:tag_name => "tag_name1", :value => "value1"},
                                         {:tag_name => "tag_name2", :value => "value2"},
                                         {:tag_name => "tag_name3", :value => "value3"}])
    assert filters.any? {|f| f.id = f1.id}
    assert !filters.any? {|f| f.id = f1.id}
  end

  test "should validate by link value" do
    Filter.all.each {|f| f.destroy}
    f1 = create(:filter, :cond => "tag_name1 = value1")
    f2 = create(:filter, :cond => "tag_name0 = value0")

    filters = Filter.validate(:contet => "content",
                              :links => [{:tag_name => "tag_name1", :value => "value1"},
                                         {:tag_name => "tag_name2", :value => "value2"},
                                         {:tag_name => "tag_name3", :value => "value3"}])
    assert filters.any? {|f| f.id = f1.id}
    assert !filters.any? {|f| f.id = f2.id}
  end


end
