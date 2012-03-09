# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :link do
    #note {Factory(:note)}
    #tag {Factory(:tag)}
    value "100"
  end

  sequence :link_value do |n|
    "value_#{n}"
  end
    

  factory :link_seq, :class => Link do
    value { FactoryGirl.generate(:link_value) }
    tag { Factory.create(:tag) }
  end
    
end
