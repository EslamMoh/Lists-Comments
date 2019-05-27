FactoryBot.define do
  factory :list do
    admin { FactoryBot.create(:user) }
    title { Faker::Company.name }
  end
end
