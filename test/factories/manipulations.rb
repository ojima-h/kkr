# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :manipulation do
    sort "append"
    object "tag_name"
    value "link_value"
  end
end
