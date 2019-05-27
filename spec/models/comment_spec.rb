require 'rails_helper'

RSpec.describe Comment, type: :model do
  # associations test
  it { should have_many(:replies).class_name('Comment').dependent(:destroy) }
  it { should belong_to(:commentable) }
  it { should belong_to(:user) }

  # validations test
  %i[content].each do |field|
    it { should validate_presence_of(field) }
  end
  it 'should validate reply to reply' do
    subject.commentable = FactoryBot.build(:reply)
    subject.commentable.commentable = FactoryBot.build(:reply)
    subject.valid? # run validations
    expect(subject.errors[:base]).to include('You cannot reply to another reply.')
  end
end
