# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    email "jd@mail.com"
    password "test123"
    password_confirmation "test123"
  end

  factory :user2, class: User do
    email "test@mail.com"
    password "test123"
    password_confirmation "test123"
  end
end
