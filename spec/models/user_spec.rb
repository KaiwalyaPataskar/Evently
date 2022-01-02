require 'rails_helper'

RSpec.describe User, type: :model do
  it 'is not valid without a name' do
    user = User.new(email: 'test@email.com')
    expect(user).to_not be_valid
  end

  it 'is not valid without a email' do
    user = User.new(name: 'TEST')
    expect(user).to_not be_valid
  end

  it 'is valid with a name and email' do
    user = User.new(name: 'xyz', email: 'test@email.com')
    expect(user).to be_valid
  end
end
