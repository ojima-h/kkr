# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :note do
    content "content"
    # tags []
    # links []
  end

  factory :note_with_links, :class => Note do
    ignore do
      links_num 3
    end
      
    content "content"
    links { (0...links_num).map { Factory.create(:link_seq) } }
  end
end
