require 'test_helper'
require 'validate'

class ParserTest < ActiveSupport::TestCase
  def setup
    @parser = ValidateParser.new
  end

  test "should parse atom" do 
    tree = @parser.parse("atom")
    assert_not_nil tree, "parsing failed"

    assert tree.validate(:content => "content", :links => [{:value => "", :tag_name => "atom"}])
    assert !tree.validate(:content => "content", :links => [{:value => "", :tag_name => "atom1"}])

    assert !tree.validate({})
  end

  
  # match
  test "should parse match" do
    tree = @parser.parse("match content")
    assert_not_nil tree, "parsing failed"
 
    assert tree.validate(:content => "content")
    assert !tree.validate(:content => "counter")

    assert !tree.validate({})
  end
  test "should parse regexp match" do
    tree = @parser.parse("match /^(https?|ftp)(:\\/\\/[-_.!~*\\'()a-zA-Z0-9;\\/?:\\@&=+\\$,%#]+)$/")
    assert_not_nil tree, "parsing failed"
    
    assert tree.validate(:content => "http://www.example.com/one")
    assert !tree.validate(:content => "another example")
  end
  test "should parse match with space" do
    tree = @parser.parse("match \"content spaces\"")
    assert_not_nil tree, "parsing failed"
    
    assert tree.validate(:content => "content spaces")
    assert !tree.validate(:content => "another example")

    assert !tree.validate({})
  end

  # include
  test "should parse include" do
    tree = @parser.parse("include content")
    assert_not_nil tree, "parsing failed"

    assert tree.validate(:content => "this is content example")

    assert !tree.validate({})
  end

  # value
  test "should parse value match eq" do
    tree = @parser.parse("tag_name = value")
    assert_not_nil tree, "parsing failed"

    assert tree.validate(:links => [{:value => "value", :tag_name => "tag_name"}])

    assert !tree.validate({})
  end
  test "should parse value match gt" do
    tree = @parser.parse("tag_name > 50")
    assert_not_nil tree, "parsing failed"

    assert tree.validate(:links => [{:value => "70", :tag_name => "tag_name"}])
    assert !tree.validate(:links => [{:value => "30", :tag_name => "tag_name"}])

    assert !tree.validate({})
  end
  test "should parse value match regexp" do
    tree = @parser.parse("tag_name ~ /[0-9]{1,2}\\/[0-9]{1,2}/")
    assert_not_nil tree, "parsing failed"

    assert tree.validate(:links => [{:value => "10/2", :tag_name => "tag_name"}])

    assert !tree.validate({})
  end

  # negation
  test "should parse negation" do
    tree = @parser.parse("not tag_name")
    assert_not_nil tree, "parsing failed"

    assert !tree.validate(:links => [{:value => "value", :tag_name => "tag_name"}])
    assert tree.validate(:links => [{:value => "value", :tag_name => "tag_name_2"}])

    assert tree.validate({})
  end
  test "should parse negation and regexp" do
    tree = @parser.parse("not tag_name ~ /[0-9]{1,2}\\/[0-9]{1,2}/")
    assert_not_nil tree, "parsing failed"

    assert !tree.validate(:links => [{:value => "10/2", :tag_name => "tag_name"}])
    assert tree.validate(:links => [{:value => "value", :tag_name => "tag_name"}])

    assert tree.validate({})
  end

  # conjunciton
  test "should parse meet" do
    tree = @parser.parse("match content and tag_name ~ /[0-9]{1,2}\\/[0-9]{1,2}/")
    assert_not_nil tree, "parsing failed"

    assert tree.validate(:content => "content", :links => [{:value => "10/2", :tag_name => "tag_name"}])
    assert !tree.validate(:content => "counter", :links => [{:value => "10/2", :tag_name => "tag_name"}])

    assert !tree.validate({})
  end
  test "should parse meet and join and not and regexp" do
    tree = @parser.parse("match content and not tag_name ~ /[0-9]{1,2}\\/[0-9]{1,2}/ or tag_name_2")
    assert_not_nil tree, "parsing failed"

    assert tree.validate(:content => "content", :links => [{:value => "value", :tag_name => "tag_name"}])
    assert tree.validate(:content => "content", :links => [{:tag_name => "tag_name_2"}])
    assert !tree.validate(:content => "content", :links => [{:value => "10/2", :tag_name => "tag_name"}])
    assert !tree.validate(:content => "counter", :links => [{:value => "value", :tag_name => "tag_name"}])

    assert !tree.validate({})
  end
  

  
end
