# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :link do
    note {Factory(:note)}
    tag {Factory(:tag)}
    value "100"
  end
end
