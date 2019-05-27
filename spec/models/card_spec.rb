require 'rails_helper'

RSpec.describe Card, type: :model do
  # associations test
  it { should have_many(:comments).dependent(:destroy) }
  it { should belong_to(:user) }
  it { should belong_to(:list) }

  # validations test
  %i[title description].each do |field|
    it { should validate_presence_of(field) }
  end
  it { should validate_uniqueness_of(:title).scoped_to(:list_id) }
end
