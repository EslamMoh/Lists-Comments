require 'rails_helper'

RSpec.describe MemberList, type: :model do
  # associations
  it { should belong_to(:user) }
  it { should belong_to(:list) }

  # validations
  it 'should validate that user role is member' do
    subject.user = FactoryBot.build(:admin_user)
    subject.valid? # run validations
    expect(subject.errors[:base]).to include('Lists can be assigned to members only')
    subject.user = FactoryBot.build(:user)
    subject.valid? # run validations
    expect(subject.errors[:base]).to_not include('Lists can be assigned to members only')
  end
end
