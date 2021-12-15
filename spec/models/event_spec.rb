require 'rails_helper'

RSpec.describe Event, type: :model do
  it 'is not valid without a eid' do
    event = Event.new(summary: 'test@email.com', description: 'sample event')
    expect(event).to_not be_valid
  end

  it 'is not valid without a summary' do
    event = Event.new(eid: 'eventid', description: 'sample event')
    expect(event).to_not be_valid
  end

  it 'is not valid without User' do
    event = Event.new(eid: 'eventid', summary: 'Test event')
    expect(event).to_not be_valid
  end

  it 'is valid with a valid user along with eid and summary' do
    user = User.create(name: 'test', email: 'test@email.com')
    event = Event.new(eid: 'eventid', summary: 'Test event', user: user)
    expect(event).to be_valid
  end
end
