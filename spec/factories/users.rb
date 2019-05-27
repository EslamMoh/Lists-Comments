FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    password { Faker::Internet.password(20, 20) }
    email { Faker::Internet.email }
    role { 'member' }
  end

  factory :admin_user, parent: :user do
    role { 'admin' }
  end
end
