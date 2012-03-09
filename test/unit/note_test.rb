require 'test_helper'

class NoteTest < ActiveSupport::TestCase
  test "should not save with nil nor empty string content" do
    note = Note.new
    note.content = nil
    assert !note.save

    note.content = ""
    assert !note.save
  end

  # association
  test "should allow empty link" do
    note = Note.new(:content => "test content")
    note.links = []
    assert note.save
  end
  test "should save auto" do
    note = create(:note_with_links)
    v = note.links.first.value
    note.links.first.value = "new_#{v}"

    assert note.save

    l = Link.find(note.links.first.id)
    assert_equal "new_#{v}", l.value 
  end

  # test for update_link
  test "should update links" do
    note = create(:note_with_links)
    link = note.links.first
    tag_1 = create(:tag, :name => "tag_name_1")
    tag_2 = create(:tag, :name => "tag_name_2")
    
    links_param = [{:value => "link_value_org", :tag_name => "tag_name_1"},
                   {:tag_name => "tag_name_2"}]
    
    assert note.update_links(links_param), "could not update links"
    assert note.links.exists?(:value => "link_value_org", :tag_id => tag_1.id), "could not make link_1"
    assert note.links.exists?(:tag_id => tag_2.id), "could not make link_2"
    assert !note.links.exists?(:value => link.value, :tag_id => link.tag.id)
  end
  test "should not add duplicated links throw update" do
    note = create(:note_with_links)
    link = note.links.first
    tag = (Tag.where(:name => "tag_name").first or create(:tag, :name => "tag_name"))

    links_param = [{:value => "link_value_org", :tag_name => "tag_name"},
                   {:value => "link_value_org", :tag_name => "tag_name"}]
    
    assert note.update_links(links_param), "could not update links"
    assert note.links.exists?(:value => "link_value_org", :tag_id => tag.id), "could not make link_1"
    assert_not_equal 2, note.links.where(:value => "link_value_org", :tag_id => tag.id).length, "could not make link_2"
  end

  test "shold create new tag with update" do
    note = create(:note_with_links)
    link = note.links.first
    create(:tag)
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
  test "should execute add manipulation" do
    manipulation = create(:append_manipulation)
    note = create(:note)
    tag = create(:tag)
    
    assert note.execute manipulation
    assert Tag.exists?(:name => "tag_name")
    assert note.links.joins(:tag).exists?(:value => "link_value", :tags => {:name => "tag_name"})
  end
  
  test "should execute delete manipulate" do
    note = create(:note_with_links)
    tags = note.links.map {|l| l.tag}
    manipulation = create(:delete_manipulation, :object => tags[0].name)

    assert note.execute(manipulation)
    assert tags.all? {|t| Tag.exists?(t.id)}
    assert !note.links.joins(:tag).exists?(:tags => {:name => tags[0].name})
    assert note.links.joins(:tag).exists?(:tags => {:name => tags[1].name})
    assert note.links.joins(:tag).exists?(:tags => {:name => tags[2].name})
  end

  test "should execute modify manipulate" do
    note = create(:note_with_links)
    link = note.links.first
    manipulation = create(:modify_manipulation,
                          :object => link.tag.name,
                          :value => "new_#{link.value}")

    assert note.execute manipulation
    assert !note.links.joins(:tag).exists?(:value => link.value,
                                           :tags => {:name => link.tag.name})
    assert note.links.joins(:tag).exists?(:value => "new_#{link.value}",
                                          :tags => {:name => link.tag.name})
  end

  test "should execute subst manipulate" do
    url = "(https?|ftp)(:\/\/[-_.!~*\'()a-zA-Z0-9;\/?:\@&=+\$,%#]+)"
    note = create(:note_with_links, :content => "http://www.google.com")
    manipulation = create(:subst_manipulation,
                          :object => url,
                          :value => "<a href=\"&\">&</a>")
    
    assert note.execute manipulation
    assert_match note.content, "<a href=\"http://www.google.com\">http://www.google.com</a>"
  end

  test "should execute attach manipulate" do
    Tag.destroy_all
    note = create(:note, :content => "content 10/2 date")
    manipulation = create(:attach_manipulation,
                          :object => "[0-9]+/[0-9]+",
                          :value => "date")
    
    assert note.execute manipulation
    assert Tag.exists?(:name => "date")
    assert note.links.joins(:tag).exists?(:value => "10/2",
                                          :tags => {:name => "date"})
  end
  
end

