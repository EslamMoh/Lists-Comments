FactoryBot.define do
  factory :comment do
    content { 'This is a testing content for a comment' }
    commentable { FactoryBot.create(:card) }
    user
  end

  factory :reply, parent: :comment do
    commentable { FactoryBot.create(:comment) }
  end
end
