require 'test_helper'

class TagTest < ActiveSupport::TestCase
  test "create" do
    tag = Tag.new(:name => "tag_name_org", :color => "red")
    assert tag.save
  end

  test "should have lightgray as default color" do
    tag = Tag.new(:name => "tag_name_org")
    assert (tag.color == "lightgray" or tag.color == "d3d3d3"), "<%s> was not lightgray" % tag.color
    assert tag.save
  end

  test "should not save tag without name" do
    tag = Tag.new
    assert !tag.save

    tag.name = ""
    assert !tag.save
  end
end
