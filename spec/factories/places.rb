FactoryBot.define do
  factory :place do
    latitude { 1.5 }
    longitude { 1.5 }
    title { 'MyString' }
    description { 'MyString' }
    user_id { create(:user).id }
  end
end
