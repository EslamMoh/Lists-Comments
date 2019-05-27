require 'rails_helper'

RSpec.describe User, type: :model do
  # Association test
  it { should have_secure_password }
  it { should have_many(:lists).with_foreign_key('admin_id') }
  it { should have_many(:member_lists).dependent(:destroy) }
  it { should have_many(:assigned_lists).through(:member_lists).source(:list) }
  it { should have_many(:cards) }
  it { should have_many(:comments) }

  # enums
  it { should define_enum_for(:role).with(%i[admin member]) }

  # validations
  %i[name email password_digest role].each do |field|
    it { should validate_presence_of(field) }
  end
  it { should validate_uniqueness_of(:email) }
  it 'should validate that email is available' do
    subject.email = 'test.com'
    subject.valid? # run validations
    expect(subject.errors[:email]).to include('only allows valid emails')
    subject.email = 'test@gmail.com'
    subject.valid? # run validations
    expect(subject.errors[:email]).to_not include('only allows valid emails')
  end
end
