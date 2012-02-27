require 'test_helper'

class NoteTest < ActiveSupport::TestCase
  test "should not save with nil nor empty string content" do
    note = Note.new
    note.content = nil
    assert !note.save

    note.content = ""
    assert !note.save
  end

  test "should allow empty link" do
    note = Note.new(:content => "test content")
    note.links = []
    assert note.save
  end

  test "should update links" do
    note = notes(:note_06)
    link = note.links.first
    tag_1 = tags(:one)
    tag_2 = tags(:two)
    links_param = [{:value => "link_value_org", :tag_name => "tag_name"},
                   {:tag_name => "tag_name_2"}]
    
    assert note.update_links(links_param), "could not update links"
    assert note.links.exists?(:value => "link_value_org", :tag_id => tag_1.id), "could not make link_1"
    assert note.links.exists?(:tag_id => tag_2.id), "could not make link_2"
    assert !note.links.exists?(:value => link.value, :tag_id => link.tag.id)
  end
  test "should not add duplicated links throw update" do
    note = notes(:note_06)
    link = note.links.first
    tag = tags(:one)
    links_param = [{:value => "link_value_org", :tag_name => "tag_name"},
                   {:value => "link_value_org", :tag_name => "tag_name"}]
    
    assert note.update_links(links_param), "could not update links"
    assert note.links.exists?(:value => "link_value_org", :tag_id => tag.id), "could not make link_1"
    assert_not_equal 2, note.links.where(:value => "link_value_org", :tag_id => tag.id).length, "could not make link_2"
  end

  test "shold create new tag with update" do
    note = notes(:note_06)
    link = note.links.first
    tag = tags(:one)
    links_param = [{:value => "link_value_valid", :tag_name => "tag_name"},
                   {:value => "link_value_invalid"},
                   {:value => "link_value_invalid_2", :tag_name => "new_tag_name"}]
    
    assert note.update_links(links_param), "could not update links"
    assert note.links.joins(:tag).exists?(:value => "link_value_valid", :tags => {:name => "tag_name"}), "could not make link_3"
    assert !note.links.exists?(:value => "link_value_invalid"), "could not make link_1"
    assert Tag.exists?(:name => "new_tag_name")
    assert note.links.exists?(:value => "link_value_invalid_2"), "could not make link_2"
    assert !note.links.exists?(:value => link.value, :tag_id => link.tag.id)
  end


  #
  # Test for Manipulations
  #
  test "should execute add manipulation correctly" do
    Filter.destroy_all
    filter = Filter.new(:cond => "tag_name")
    filter.manipulations << Manipulation.new(:sort => "append", :object => "new_tag", :value => "link_value")
    assert filter.save, "test could not be prepared"

    note = notes(:note_06)
    tag = tags(:tag_03)
    assert note.update_links([{:value => "link_value", :tag_id => "tag_name"}]), "preparation failed"
    
    assert note.execute_manipulations [filter]
    assert Tag.exists?(:name => "new_tag")
    assert note.links.joins(:tag).exists?(:value => "link_value", :tags => {:name => "new_tag"})
  end
  test "should execute delete manipulate correctly" do
    Filter.destroy_all
    filter = Filter.new(:cond => "tag_name_3")
    filter.manipulations << Manipulation.new(:sort => "delete", :object => "tag_name_4", :value => "link_value")
    assert filter.save, "test could not be prepared"

    note = notes(:note_06)
    tag_03 = tags(:tag_03)
    tag_04 = tags(:tag_04)
    assert note.execute_manipulations([filter]), "execute_manipulation returned false"
    assert Tag.exists?(tag_04.id), "execute_manipulation does not change(1)"
    assert !note.tags.exists?(:name => "tag_name_4"), "execute_manipulation does not change(2)"
    assert note.tags.exists?(:name => "tag_name_3"), "execute_manipulation does not change(3)"
  end
  test "should execute modify manipulate correctly" do
    Filter.destroy_all
    filter = Filter.new(:cond => "tag_name")
    filter.manipulations << Manipulation.new(:sort => "modify", :object => "tag_name_3", :value => "link_value_new")
    assert filter.save, "test could not be prepared"

    note = notes(:note_06)
    tag = tags(:tag_03)
    assert note.execute_manipulations [filter]
    assert note.links.joins(:tag).exists?(:value => "link_value_new", :tags => {:name => "tag_name_3"})
  end
  test "should execute subst manipulate correctly" do
    Filter.destroy_all
    filter = Filter.new(:cond => "tag_name")
    filter.manipulations << Manipulation.new(:sort => "subst", :object => "[0-9]+/[0-9]+", :value => "date:&")
    assert filter.save, "test could not be prepared"

    note = notes(:note_04)
    assert note.execute_manipulations([filter]), "execution returned false"
    assert_match  /date:12\/3/, note.content, "manipulation did not executed correctly"
  end
  test "should execute attach manipulate correctly" do
    Filter.destroy_all
    filter = Filter.new(:cond => "tag_name")
    filter.manipulations << Manipulation.new(:sort => "attach", :object => "[0-9]+/[0-9]+", :value => "date")
    assert filter.save, "test could not be prepared"

    note = notes(:note_04)
    assert note.execute_manipulations([filter]), "execution returned false"
    assert Tag.exists?(:name => "date")
    assert note.links.joins(:tag).exists?(:value => "12/3", :tags => {:name => "date"}), "manipulation did not executed correctly"
  end
  
end

