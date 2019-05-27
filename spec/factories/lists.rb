FactoryBot.define do
  factory :list do
    admin { user }
    title { Faker::Company.name }
  end
end
