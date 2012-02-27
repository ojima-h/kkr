# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    email "david@example.com"
    encrypted_password "$2a$10$IHEiLxrbnzbdQEDzU5uLfeAd6iOuy6WUOVmc2cMEL.XUzHJYbOiF2"
  end
end
