FactoryBot.define do
  factory :card do
    title { Faker::Company.name }
    description { 'Testing description' }
    user
    list
  end
end
