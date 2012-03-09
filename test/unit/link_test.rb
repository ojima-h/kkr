require 'test_helper'

class LinkTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "create" do
    note = create(:note)
    tag = create(:tag)
    link = Link.new(:note_id => note.id, :tag_id => tag.id, :value => "100")
    assert link.save
  end

  # test "should not save link without note" do
  #   tag = tags(:one)
  #   link = Link.new(:tag_id => tag.id, :value => "100")
  #   assert !link.save
  # end
  test "should not save link without tag" do
    note = create(:note)
    link = Link.new(:note_id => note.id, :value => "100")
    assert !link.save
  end
  
  test "should have empty string as defalut value" do
    note = create(:note)
    tag = create(:tag)
    link = Link.new(:note_id => note.id, :tag_id => tag.id)
    assert_equal link.value, ""
    assert link.save
  end

  test "should allow duplicate link" do
    note = create(:note)
    tag = create(:tag)
    link_1 = Link.new(:value => "link_vaule_org", :note_id => note.id, :tag_id => tag.id)
    link_2 = Link.new(:value => "link_vaule_org", :note_id => note.id, :tag_id => tag.id)
    assert link_1.save
    assert link_2.save
  end
end
