FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    birthdate { Faker::Date.birthday(min_age: 18, max_age: 65) }
    password { Faker::Internet.password(min_length: 6, max_length: 12) }
  end
end
