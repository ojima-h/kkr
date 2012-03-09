# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :tag do
    #name "name"
    name { FactoryGirl.generate(:tag_name) }
    color "color"
    # notes []
    # links []
  end

  sequence :tag_name do |n|
    "name_#{n}"
  end
end
