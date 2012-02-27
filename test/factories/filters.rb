# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :filter do
    cond "todo"
    manipulations {[Factory(:manipulation)]}
  end
end
