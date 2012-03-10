# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :manipulation do
    sort "append"
    object "tag_name"
    value "link_value"
  end
  factory :append_manipulation, :class => Manipulation do
    sort "append"
    object "tag_name"
    value "link_value"
  end
  factory :delete_manipulation, :class => Manipulation do
    sort "delete"
    object "tag_name"
    value ""
  end
  factory :modify_manipulation, :class => Manipulation do
    sort "modify"
    object "tag_name"
    value "new_tag_name"
  end
  factory :subst_manipulation, :class => Manipulation do
    sort "subst"
    object "(https?|ftp)(:\/\/[-_.!~*\'()a-zA-Z0-9;\/?:\@&=+\$,%#]+)"
    value "<a href=\"&\">&</a>"
  end
  factory :attach_manipulation, :class => Manipulation do
    sort "attach"
    object "[0-9]{2}/[0-9]{2}"
    value "&"
  end

  sequence :manipulatoin_sort do |n|
    ["append", "delete", "modify", "subst", "attach"][n % 5]
  end
  sequence :manipulation_object do |n|
    "tag_name_#{n}"
  end

  factory :manipulation_seq do
    
end
