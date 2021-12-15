FactoryBot.define do
  factory :user do
    name { 'Test User 1' }
    email { 'testuser1@email.com' }
  end

  factory :event do
    eid { 'EID1' }
    summary { 'Sample Event' }
    description { 'MyString' }
    status { 'MyString' }
    organizer { 'MyString' }
    user
  end
end
