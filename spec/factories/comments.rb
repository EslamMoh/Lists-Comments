FactoryBot.define do
  factory :comment do
    content { 'This is a testing content for a comment' }
    commentable { card }
    user
  end

  factory :reply, parent: :comment do
    commentable { comment }
  end
end
