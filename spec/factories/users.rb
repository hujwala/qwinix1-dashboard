FactoryGirl.define do
  factory :user do
    name "name of user"
    username "name of user"
    email"email@gmail.com"
    status "status"
    user_type "type of user"
    password "Password@1"
    password_confirmation "Password@1"
  end
end
