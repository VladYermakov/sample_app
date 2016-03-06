FactoryGirl.define do
  factory :user do
    name     "Vlad Yermakov"
    email    "yermakov.v.o@gmail.com"
    password "12345678"
    password_confirmation "12345678"
  end
end