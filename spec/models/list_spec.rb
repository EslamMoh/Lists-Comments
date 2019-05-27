require 'rails_helper'

RSpec.describe List, type: :model do
  # associations
  it { should belong_to(:admin).class_name('User') }
  it { should have_many(:member_lists).dependent(:destroy) }
  it { should have_many(:members).through(:member_lists).source(:user) }
  it { should have_many(:cards).dependent(:destroy) }
  it { should have_many(:comments).through(:cards) }

  # validations
  it { should validate_presence_of(:title) }
  it { should validate_uniqueness_of(:title).scoped_to(:admin_id) }
end
