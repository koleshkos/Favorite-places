FactoryBot.define do
  factory :user do
    sequence(:username) { |n| "Username#{n}" }
    sequence(:email) { |n| "me_user_#{n}@example.com" }
    sequence(:name) { |n| "User#{n}" }
    sex { 'female' }
    date_of_birth { DateTime.now }
    confirmed_at { DateTime.now }
    sequence(:confirmation_token) { |n| "fjklLSyLDldwlwl#{n}" }
    after(:build) { |u| u.password_confirmation = u.password = '$$RRrr33' }
  end
end
