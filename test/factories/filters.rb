# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :filter do
    ignore do
      sort { "append" }
    end
    
    cond "todo"
    manipulations { [Factory(:manipulation, :sort => sort)] }
  end
end
